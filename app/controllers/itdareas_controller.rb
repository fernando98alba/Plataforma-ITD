class ItdareasController < ApplicationController
  before_action :get_itdarea
  before_action :get_itdcon
  before_action :get_empresa
  before_action :get_participants, only: [:update]
  before_action :authenticate_user!
  before_action :correct_user, only: [:show, :update]
  before_action :correct_completed, only: [:show]
  before_action :correct_empresa_itdcon
  before_action :correct_user_edit, only: [:update]
  before_action :get_points, only: [:show]

  def show
  end
  
  def update
    @itdarea_params = itdarea_params
    itdind_ids = []
    @itdarea.itdinds.each do |itdind|
      itdind_ids.push(itdind.user_id)
    end
    new_itdinds = []
    delete_itdinds = []
    @itdind = nil
    @itdarea_params.keys.each do |key|
      if @itdarea_params[key] == "1"
        new_itdinds.push(key.to_i)
      end
      if @itdarea_params[key] == "0" 
        if itdind_ids.include? key.to_i
          delete_itdinds.push(key.to_i)
        end
      end
    end
    if new_itdinds.length > 0
      new_itdinds.each do |param|
        if @itdarea.itdinds.find_by(user_id: param) == nil
          user = User.find_by(id: param.to_i) #Cambiar a participants
          if user != current_user
            itdind = user.itdinds.build()
            itdind.itdcon = @itdcon
            itdind.itdarea = @itdarea
            itdind.save()
          else
            @itdind = current_user.itdinds.build()
            @itdind.itdcon = @itdcon
            @itdind.itdarea = @itdarea
            @itdind.save
          end
        end
      end
      if delete_itdinds.length > 0
        delete_itdinds.each do |param|
          itdind = @itdarea.itdinds.find_by(user_id: param)
          itdind.delete
        end
      end
      check_if_completed
      if @itdind
        redirect_to edit_empresa_itdcon_itdind_path(@empresa, @itdcon, @itdind)
      else
        redirect_to empresa_itdcons_path(@empresa.id), notice: "Participantes de la medición actualizados."
      end
    else
      redirect_to empresa_itdcons_path(@empresa.id), notice: "Debe elegir al menos un miembro para realizar el ITD"
    end
  end

  private

  def check_if_completed
    calculate_bigger_itd @itdarea, @itdarea.itdinds
    if @itdarea[:completed] == true
      calculate_bigger_itd @itdcon, @itdcon.itdareas
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

  def get_itdcon
    @itdcon = Itdcon.find_by(id: params[:itdcon_id])
  end
  def get_empresa
    @empresa = Empresa.find_by(id: params[:empresa_id])
    redirect_to root_path, notice: "Acción invalida." if !@empresa
  end
  def get_itdarea
    @itdarea = Itdarea.find_by(id: params[:id])
  end

  def get_participants
    @participants = []
    @empresa.users.where(area_id: [nil, @itdarea.area.id]).each do |user|
      if user.accepted_or_not_invited?
        @participants.push(user)
      end
    end
    @itdarea.itdinds.each do |itd|
      if !@participants.include? itd.user
        if user.accepted_or_not_invited?
          @participants.push(user)
        end
      end
    end
  end
  def correct_user
    redirect_to empresa_itdcons_url(@empresa), notice: "No tienes permiso realizar esa acción." if !(current_user.empresa == @empresa)
  end
  def correct_user_edit
    redirect_to empresa_itdcons_url(@empresa), notice: "No tienes permiso realizar esa acción." if !(current_user.is_admin == "1")
  end
  def correct_completed
    redirect_to empresa_itdcons_url(@empresa), notice: "Todos deben responder la encuesta antes de ver los resultados." if (!@itdcon.completed)
  end
  def correct_empresa_itdcon
    redirect_to root_path, notice: "No tienes permiso realizar esa acción." if !(@itdarea.itdcon == @itdcon and @itdcon.empresa == @empresa)
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
            point_elemento += @itdarea[driver.identifier]
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
  def itdarea_params
    permited = []
    @participants.each do |participant|
      permited.push(participant.id.to_s)
    end
    params.require(:itdarea).permit(permited)
  end
end
