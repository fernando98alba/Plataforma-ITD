class ItdconsController < ApplicationController
  before_action :get_itdcon, only: [ :show, :edit, :update, :destroy ]
  before_action :get_points, only: [ :show]
  before_action :get_empresa
  before_action :get_participants, only: [ :index, :create]

  def index
    @itdcons = @empresa.itdcons.order(id: :asc)
    @last_itdcon = @itdcons.last
  end
  def create
    @itdcon = @empresa.itdcons.build()
    puts itdcon_params
    @itdind = nil
    #ADD any_participant_selected
    #respond_to do |format|
    if itdcon_params.values.include? "1"
      if @itdcon.save
        itdcon_params.keys.each do |param|
          if itdcon_params[param].to_i == 1
            user = User.find_by(id: param.to_i) #Cambiar a paerticipants
            if user != current_user 
              itdind = user.itdinds.build()
              itdind.itdcon = @itdcon
              itdind.save()
              verifier = Verificador.new
              verifier.itdind = itdind
              verifier.save
            else
              @itdind = current_user.itdinds.build()
              @itdind.itdcon = @itdcon
              @itdind.save
              verifier = Verificador.new
              verifier.itdind = @itdind
              verifier.save
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

  private
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
        @points_hab[habilitador.name] = point_habilitador
        point_dat += point_habilitador
      end
      point_dat = point_dat/dat.habilitadors.count.to_f
      @points_dat[dat.name] = point_dat
    end
  end
  
  def get_empresa
    @empresa = Empresa.find_by(id:params[:empresa_id])
  end

  def get_participants
    @participants = @empresa.users.all
  end

  def itdcon_params
    permited = []
    @participants.each do |participant|
      permited.push(participant.id.to_s)
    end
    params.require(:itdcon).permit(permited)
  end
end
