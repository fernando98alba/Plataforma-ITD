class ItdconsController < ApplicationController
  before_action :get_itdcon, only: [ :show, :edit, :update, :destroy ]
  before_action :get_points, only: [ :show]
  before_action :get_empresa
  def index
    @itdcon = @empresa.itdcons
  end
  def create
    @itdcon = @empresa.itdcons.build()
    #respond_to do |format|
    if @itdcon.save
      redirect_to new_empresa_itdcon_itdind_path(@empresa.id, @itdcon.id)
    else #REVISAR EL ELSE
      redirect_to new_empresa_itdcon_path(@empresa.id)
    end
    #end
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
      @points_dat['Capital ' + dat.name] = point_dat
    end
  end
  def get_empresa
    @empresa = Empresa.find_by(id:params[:empresa_id])
  end
end
