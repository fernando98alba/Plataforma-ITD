class ItdsinsController < ApplicationController
  before_action :get_itdsin, only: [:show]
  before_action :get_points, only: [ :show]
  def new
    @itdsin = Itdsin.new
  end

  def create
    @itdsin = Itdsin.new(itdsin_params)
    check_if_completed()
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
  
  def check_if_completed
    #if !itdsin_params.values.include? ""
     # @itdsin[:completed] = true
    #end
    (1..91).each do |index|
      question = "p" + index.to_s
      if !itdsin_params[question] 
        @itdsin[question] = rand(0..4) #ELIMINAAAR
      else
        @itdsin[question] = itdsin_params[question].to_i
      end
    end
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
            puts
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
  end

  def itdsin_params
    if params[:itdsin]
      params.require(:itdsin).fetch(:p1, :p2, :p3, :p4, :p5, :p6, :p7, :p8, :p9, :p10, :p11, :p12, :p13, :p14, :p15, :p16, :p17, :p18, :p19, :p20, :p21, :p22, :p23, :p24, :p25, :p26, :p27, :p28, :p29, :p30, :p31, :p32, :p33, :p34, :p35, :p36, :p37, :p38, :p39, :p40, :p41, :p42, :p43, :p44, :p45, :p46, :p47, :p48, :p49, :p50, :p51, :p52, :p53, :p54, :p55, :p56, :p57, :p58, :p59, :p60, :p61, :p62, :p63, :p64, :p65, :p66, :p67, :p68, :p69, :p70, :p71, :p72, :p73, :p74, :p75, :p76, :p77, :p78, :p79, :p80, :p81, :p82, :p83, :p84, :p85, :p86, :p87, :p88, :p89, :p90, :p91)
    else
      auxiliar_params = {}
    end
  end

end
