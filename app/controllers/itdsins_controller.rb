class ItdsinsController < ApplicationController
  before_action :get_itdsin, only: [:show]
  before_action :get_points, only: [ :show]
  before_action :not_signed_in
  def new
    @itdsin = Itdsin.new
  end

  def create
    @itdsin_params = itdsin_params
    @itdsin = Itdsin.new(itdsin_params)
    calculate_itdsin
    respond_to do |format|
      if @itdsin.save
        format.html { redirect_to itdsin_path(@itdsin), notice: "El Itd se creó correctamente." }
      else #REVISAR EL ELSE
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def show
    
  end

  private 

  def not_signed_in
    redirect_to root_path, notice: "No tienes permiso para realizar esa acción." if current_user
  end

  def calculate_itdsin
    madurez = 0
    habilitadores = []
    Dat.all.each do |dat|
      point_dat = 0
      dat.habilitadors.each do |habilitador|
        point_habilitador = 0
        habilitador.elementos.each do |elemento|
          point_elemento = 0
          elemento.drivers.each do |driver|
            point_elemento += @itdsin[driver.identifier]
          end
          point_elemento = point_elemento/elemento.drivers.count.to_f
          point_elemento = point_elemento*100.0/4
          point_habilitador += point_elemento 
        end
        point_habilitador = point_habilitador/habilitador.elementos.count.to_f
        point_dat += point_habilitador
        habilitadores.push(point_habilitador)
      end
      point_dat = point_dat/dat.habilitadors.count.to_f
      madurez += point_dat*dat.ponderador
    end
    @itdsin.maturity_score = madurez
    alignment_mean = habilitadores.sum(0.0)/habilitadores.size
    num_sum = habilitadores.sum(0.0) {|element| (element - alignment_mean) ** 2}
    variance = num_sum / (habilitadores.size)  
    std_dev = Math.sqrt(variance)
    @itdsin.alignment_score = std_dev
    Madurez.all.each do |level| #HACER LO MISMO PARA LOS IND
      if madurez <= level.max and madurez >= level.min
        @itdsin.madurez = level
        break
      end
    end
    Alineamiento.all.each do |level|
      if std_dev <= level.max and std_dev >= level.min
        @itdsin.alineamiento = level
        break
      end
    end
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
            point_elemento += @itdsin[driver.identifier]
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

  def get_itdsin
    @itdsin = Itdsin.find_by(id: params[:id])
    redirect_to root_path, notice: "Acción invalida." if !@itdsin
  end

  def itdsin_params
    permited = []
    Driver.all.each do |driver|
      permited.push(driver.identifier)
    end
    if params[:itdsin]
      params.require(:itdsin).permit(permited)
    else
      auxiliar_params = {}
    end
  end

end
