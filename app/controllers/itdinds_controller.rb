class ItdindsController < ApplicationController

  before_action :get_itdind
  before_action :get_itdcon
  def edit
  end
  def update
    check_if_completed()
    if @itdind[:completed] == true
      calculate_itdind
    end
    respond_to do |format|
      if @itdind.save
        if @itdind[:completed] == true
          calculate_itdcon()
          if @itdcon[:completed] == true
            format.html { redirect_to empresa_itdcon_path(@itdcon.empresa, @itdcon), notice: "El Itd se creó correctamente." }
          else
            format.html { redirect_to empresa_itdcons_path(@itdcon.empresa), notice: "El Itd se creó correctamente." }
          end
        else
          format.html { redirect_to edit_empresa_itdcon_itdind_path(@itdcon.empresa, @itdcon, @itdind), notice: "Respuestas guardadas correctamente." }
        end
      else #REVISAR EL ELSE
        format.html { redirect_to edit_empresa_itdcon_itdind_path(@itdcon.empresa, @itdcon, @itdind), status: :unprocessable_entity }
      end
    end
  end

  private
  def check_if_completed
    #if !itdind_params.values.include? ""
     # @itdind[:completed] = true
    #end
    (1..91).each do |index|
      question = "p" + index.to_s
      if !itdind_params.values.is_a? Numeric
        @itdind[question] = rand(0..4) #ELIMINAAAR
      end
    end
    @itdind[:completed] = true
  end

  def calculate_itdind
    madurez = 0
    habilitadores = []
    Dat.all.each do |dat|
      point_dat = 0
      dat.habilitadors.each do |habilitador|
        point_habilitador = 0
        habilitador.elementos.each do |elemento|
          point_elemento = 0
          elemento.drivers.each do |driver|
            point_elemento += @itdind[driver.identifier]
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
    @itdind.maturity_score = madurez
    alignment_mean = habilitadores.sum(0.0)/habilitadores.size
    num_sum = habilitadores.sum(0.0) {|element| (element - alignment_mean) ** 2}
    variance = num_sum / (habilitadores.size)  
    std_dev = Math.sqrt(variance)
    @itdind.alignment_score = std_dev
    Madurez.all.each do |level| #HACER LO MISMO PARA LOS IND
      if madurez <= level.max and madurez >= level.min
        @itdind.madurez = level
        break
      end
    end
    Alineamiento.all.each do |level|
      if std_dev <= level.max and std_dev >= level.min
        @itdind.alineamiento = level
        break
      end
    end
  end

  def calculate_itdcon
    itdinds = @itdcon.itdinds.where(completed: true)
    if itdinds.length == @itdcon.itdinds.count
      @itdcon[:completed] = true
    end
     #Atomicidad, y si dos cambian a true al mismo tiempo?
    Driver.all.each do |driver|
      @itdcon[driver.identifier] = 0
      itdinds.each do |itdind|
        @itdcon[driver.identifier] += itdind[driver.identifier]
      end
      @itdcon[driver.identifier] = @itdcon[driver.identifier]/itdinds.length.to_f
    end
    @itdcon["maturity_score"] = 0
    @itdcon["alignment_score"] = 0
    itdinds.each do |itdind|
      @itdcon["maturity_score"] += itdind["maturity_score"]
      @itdcon["alignment_score"] += itdind["alignment_score"]
    end
    @itdcon["maturity_score"] = @itdcon["maturity_score"]/itdinds.length.to_f
    @itdcon["alignment_score"] = @itdcon["alignment_score"]/itdinds.length.to_f
    Madurez.all.each do |level| #HACER LO MISMO PARA LOS IND
      if @itdcon["maturity_score"] <= level.max and @itdcon["maturity_score"] >= level.min
        @itdcon.madurez = level
        break
      end
    end
    Alineamiento.all.each do |level|
      if @itdcon["alignment_score"] <= level.max and @itdcon["alignment_score"] >= level.min
        @itdcon.alineamiento = level
        break
      end
    end
    @itdcon.save
  end

  def get_itdcon
    @itdcon = Itdcon.find_by(id: params[:itdcon_id])
  end
  def itdind_params
    params.require(:itdind).permit(:p1, :p2, :p3, :p4, :p5, :p6, :p7, :p8, :p9, :p10, :p11, :p12, :p13, :p14, :p15, :p16, :p17, :p18, :p19, :p20, :p21, :p22, :p23, :p24, :p25, :p26, :p27, :p28, :p29, :p30, :p31, :p32, :p33, :p34, :p35, :p36, :p37, :p38, :p39, :p40, :p41, :p42, :p43, :p44, :p45, :p46, :p47, :p48, :p49, :p50, :p51, :p52, :p53, :p54, :p55, :p56, :p57, :p58, :p59, :p60, :p61, :p62, :p63, :p64, :p65, :p66, :p67, :p68, :p69, :p70, :p71, :p72, :p73, :p74, :p75, :p76, :p77, :p78, :p79, :p80, :p81, :p82, :p83, :p84, :p85, :p86, :p87, :p88, :p89, :p90, :p91, :itdcon_id)
  end
  def get_itdind
    @itdind = Itdind.find_by(id: params[:id])
  end
end
