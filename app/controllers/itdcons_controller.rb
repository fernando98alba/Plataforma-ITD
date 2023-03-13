class ItdconsController < ApplicationController
  before_action :get_itdcon, only: [ :show, :update, :destroy ]
  before_action :get_empresa
  before_action :get_participants, only: [ :index, :create, :update]
  before_action :authenticate_user!
  before_action :correct_user
  before_action :correct_user_admin, only: [ :create, :update, :destroy ]
  before_action :itdcon_pending, only: [ :create]
  before_action :correct_empresa, except: [:index, :create]
  before_action :correct_completed, only: [ :show]
  before_action :not_completed, only: [ :update, :destroy]
  before_action :get_points, only: [ :show]

  def index
    @itdcons = @empresa.itdcons.order(id: :asc)
    get_all_points
    @last_itdcon = @itdcons.where(completed: true).last
    @last_not_completed_itdcon = @itdcons.find_by(completed: false)
  end

  def create
    @itdcon = @empresa.itdcons.build()
    @itdind = nil
    #ADD any_participant_selected
    #respond_to do |format|
    @itdcon_params = create_params
    puts "Values: #{@itdcon_params}"
    puts "Areas: #{@empresa.areas.length}"
    puts "Users: #{@empresa.user_ids}"
    if @itdcon_params.values.include? "1"
      if @itdcon.save
        if @empresa.areas.length == 0
          @itdcon_params.keys.each do |param|
            if @itdcon_params[param].to_i == 1
              user = @empresa.users.find_by(id: param.to_i) #Cambiar a paerticipants
              if user != current_user 
                itdind = user.itdinds.build()
                itdind.itdcon = @itdcon
                itdind.save()
              else
                puts "AAAA"
                @itdind = current_user.itdinds.build()
                @itdind.itdcon = @itdcon
                @itdind.save
              end
            end
          end
        else
          @itdcon_params.keys.each do |param|
            if @itdcon_params[param].to_i == 1
              itdarea = @itdcon.itdareas.build
              area = Area.find_by(id: param.to_i)
              itdarea.area = area
              if itdarea.save
                area.users.each do |user|
                  itdind = user.itdinds.build()
                  itdind.itdcon = @itdcon
                  itdind.itdarea = itdarea
                  itdind.save()
                end
              end
            end
          end
        end
        if @itdind
          redirect_to edit_empresa_itdcon_itdind_path(@empresa, @itdcon, @itdind)
        else
          redirect_to empresa_itdcons_path(@empresa.id)
        end
      else #REVISAR EL ELSE
        redirect_to empresa_itdcons_path(@empresa.id)
      end
    else
      redirect_to empresa_itdcons_path(@empresa.id), notice: "Debe elegir al menos un miembro para realizar el ITD"
    end
  end

  def show
  end

  def update
    @itdcon_params = update_params
    itdind_ids = []
    if @itdcon.itdareas.length == 0
      @itdcon.itdinds.each do |itd|
        itdind_ids.push(itd.user_id)
      end
    else
      @itdcon.itdareas.each do |itd|
        itdind_ids.push(itd.area_id)
      end
    end
    new_itdinds = []
    delete_itdinds = []
    @itdind = nil
    @itdcon_params.keys.each do |key|
      if @itdcon_params[key] == "1"
        new_itdinds.push(key.to_i)
      end
      if @itdcon_params[key] == "0" 
        if itdind_ids.include? key.to_i
          delete_itdinds.push(key.to_i)
        end
      end
    end
    if new_itdinds.length > 0
      if @itdcon.itdareas.length == 0
        new_itdinds.each do |param|
          if @itdcon.itdinds.find_by(user_id: param) == nil
            user = User.find_by(id: param.to_i) #Cambiar a participants
            if user != current_user
              itdind = user.itdinds.build()
              itdind.itdcon = @itdcon
              itdind.save()
            else
              @itdind = current_user.itdinds.build()
              @itdind.itdcon = @itdcon
              @itdind.save
            end
          end
        end
        if delete_itdinds.length > 0
          delete_itdinds.each do |param|
            itdind = @itdcon.itdinds.find_by(user_id: param)
            itdind.delete
          end
        end
      else
        new_itdinds.each do |param|
          if @itdcon.itdareas.find_by(area_id: param) == nil
            itdarea = @itdcon.itdareas.build
            area = Area.find_by(id: param.to_i)
            itdarea.area = area
            if itdarea.save
              area.users.each do |user|
                itdind = user.itdinds.build()
                itdind.itdcon = @itdcon
                itdind.itdarea = itdarea
                itdind.save()
              end
            end
          end
        end
        if delete_itdinds.length > 0
          delete_itdinds.each do |param|
            itdarea = @itdcon.itdareas.find_by(area_id: param)
            itdarea.delete
          end
        end
      end
      check_if_completed
      if @itdind
        redirect_to edit_empresa_itdcon_itdind_path(@empresa, @itdcon, @itdind)
      else
        redirect_to empresa_itdcons_path(@empresa.id), notice: "Medición actualizados."
      end
    else
      redirect_to empresa_itdcons_path(@empresa.id), notice: "Debe elegir al menos un miembro para realizar el ITD"
    end
  end

  def destroy
    if @itdcon.delete
      redirect_to empresa_itdcons_path(@empresa), notice: "Medición eliminada con éxito"
    else
      redirect_to empresa_itdcons_path(@empresa), notice: "Ocurrió un error al eliminar la medición"
    end
  end
  private

  def check_if_completed
    if @itdcon.itdareas.length > 0
      @itdcon.itdareas.each do |itdarea|
        calculate_bigger_itd itdarea, itdarea.itdinds
      end
      calculate_bigger_itd @itdcon, @itdcon.itdareas
    else
      calculate_bigger_itd @itdcon, @itdcon.itdinds
    end
  end

  def calculate_bigger_itd itd, itd_collection
    itdinds = itd_collection.where(completed: true)
    if itdinds.length == itd_collection.count
      itd[:completed] = true
    else
      itd[:completed] = false
    end
     #Atomicidad, y si dos cambian a true al mismo tiempo?
    if itd[:completed] == true
      Driver.all.each do |driver|
        itd[driver.identifier] = 0
        itdinds.each do |itdind|
          itd[driver.identifier] += itdind[driver.identifier]
        end
        itd[driver.identifier] = itd[driver.identifier]/itdinds.length.to_f
      end
      itd["maturity_score"] = 0
      itd["alignment_score"] = 0
      itdinds.each do |itdind|
        itd["maturity_score"] += itdind["maturity_score"]
        itd["alignment_score"] += itdind["alignment_score"]
      end
      itd["maturity_score"] = itd["maturity_score"]/itdinds.length.to_f
      itd["alignment_score"] = itd["alignment_score"]/itdinds.length.to_f
      Madurez.all.each do |level| #HACER LO MISMO PARA LOS IND
        if itd["maturity_score"] <= level.max and itd["maturity_score"] >= level.min
          itd.madurez = level
          break
        end
      end
      Alineamiento.all.each do |level|
        if itd["alignment_score"] <= level.max and itd["alignment_score"] >= level.min
          itd.alineamiento = level
          break
        end
      end
    end
    itd.save
  end

  def correct_user
    redirect_to root_path, notice: "No tienes permiso realizar esa acción." if @empresa != current_user.empresa
  end

  def correct_user_admin
    redirect_to empresa_itdcons_path(@empresa.id), notice: "Solo el administrador puede realizar esa acción." if current_user.is_admin == "0"
  end

  def itdcon_pending
    redirect_to empresa_itdcons_path(@empresa.id), notice: "Aún hay una medición pendiednte." if @empresa.itdcons.find_by(completed: false) != nil
  end

  def correct_completed
    redirect_to empresa_itdcons_path(@empresa.id), notice: "Todos deben responder la encuesta antes de ver los resultados." if (!@itdcon.completed)
  end

  def not_completed
    redirect_to empresa_itdcons_path(@empresa.id), notice: "No puede agregar miembros a una medición finalizada." if (@itdcon.completed) #Validar
  end

  def correct_empresa
    redirect_to root_path, notice: "No tienes permiso realizar esa acción." if @empresa != @itdcon.empresa
  end

  def get_itdcon
    @itdcon = Itdcon.find_by(id: params[:id])
  end

  def get_points
    @points_dat = {}
    @points_hab = {}
    Dat.all.each do |dat|
      point_dat = 0
      dat.habilitadors.each do |habilitador|
        point_habilitador = 0
        habilitador.elementos.each do |elemento|
          point_elemento = 0
          elemento.drivers.each do |driver|
            point_elemento += @itdcon[driver.identifier]
          end
          point_elemento = point_elemento/elemento.drivers.count.to_f
          point_elemento = point_elemento*100/4.to_f
          point_habilitador += point_elemento 
        end
        point_habilitador = point_habilitador/habilitador.elementos.count.to_f
        @points_hab[habilitador.name.downcase] = point_habilitador
        point_dat += point_habilitador
      end
      point_dat = point_dat/dat.habilitadors.count.to_f
      @points_dat[dat.name.downcase] = point_dat
    end
  end

  def get_all_points
    @all_points_dat = {}
    @itdcons.where(completed: true).each do |itd|
      @all_points_dat[itd.id] = {}
      Dat.all.each do |dat|
        point_dat = 0
        dat.habilitadors.each do |habilitador|
          point_habilitador = 0
          habilitador.elementos.each do |elemento|
            point_elemento = 0
            elemento.drivers.each do |driver|
              point_elemento += itd[driver.identifier]
            end
            point_elemento = point_elemento/elemento.drivers.count.to_f
            point_elemento = point_elemento*100/4.to_f
            point_habilitador += point_elemento 
          end
          point_habilitador = point_habilitador/habilitador.elementos.count.to_f
          point_dat += point_habilitador
        end
        point_dat = point_dat/dat.habilitadors.count.to_f
        @all_points_dat[itd.id][dat.name.downcase] = point_dat
      end
    end
  end
  
  def get_empresa
    @empresa = Empresa.find_by(id:params[:empresa_id])
    redirect_to root_path, notice: "Acción invalida." if !@empresa
  end

  def get_participants
    @participants = []
    @empresa.users.each do |user|
      if user.accepted_or_not_invited?
        @participants.push(user)
      end
    end
  end

  def create_params
    permited = []
    if @empresa.areas.length == 0
      @participants.each do |participant|
        permited.push(participant.id.to_s)
      end
    else
      @empresa.areas.each do |area|
        permited.push(area.id.to_s)
      end
    end
    params.require(:itdcon).permit(permited)
  end
  def update_params
    permited = []
    if @itdcon.itdareas.length == 0
      @participants.each do |participant|
        permited.push(participant.id.to_s)
      end
    else
      @empresa.areas.each do |area|
        permited.push(area.id.to_s)
      end
    end
    params.require(:itdcon).permit(permited)
  end
end
