class ItdindsController < ApplicationController

  before_action :get_itdind
  before_action :get_itdcon
  before_action :get_empresa
  before_action :get_points, only: [ :show]
  before_action :authenticate_user!
  before_action :correct_user_edit, only: [:edit, :update] #CHECK QUE ITDIND.ITDCON = @ITDCON
  before_action :correct_user_show, only: [:show]
  before_action :correct_empresa_itdcon

  def show
  end
  
  def edit
    if @itdind[:completed]
      redirect_to empresa_itdcons_path(@itdcon.empresa), notice: "Medición ya esta completada."
    end
  end

  def update
    @parameters = itdind_params
    check_if_completed()
    if @itdind[:completed] == true
      calculate_itdind
    end
    update_verificators
    respond_to do |format|
      if @itdind.save
        if @itdind[:completed] == true
          calculate_itdcon()
          if @itdcon[:completed] == true
            format.html { redirect_to empresa_itdcon_path(@itdcon.empresa, @itdcon), data: {turbo: false}, notice: "El Itd se creó correctamente." }
          else
            format.html { redirect_to empresa_itdcons_path(@itdcon.empresa), data: {turbo: false}, notice: "El Itd se creó correctamente." }
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

  def correct_user_edit
    redirect_to root_path, notice: "No tienes permiso realizar esa acción." if current_user != @itdind.user
  end

  def correct_user_show
    redirect_to root_path, notice: "No tienes permiso realizar esa acción." if (current_user != @itdind.user and !current_user.is_admin)
  end
  
  def correct_empresa_itdcon
    redirect_to root_path, notice: "No tienes permiso realizar esa acción." if !(@itdind.itdcon == @itdcon and @itdcon.empresa == @empresa)
  end

  def check_if_completed
    #if !itdind_params.values.include? ""
     # @itdind[:completed] = true
    #end
    (1..91).each do |index|
      question = "p" + index.to_s
      if !@parameters[question] 
        @itdind[question] = rand(0..4) #ELIMINAAAR
      else
        @itdind[question] = @parameters[question].to_i
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
            point_elemento += @itdind[driver.identifier]
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

  def get_itdcon
    @itdcon = Itdcon.find_by(id: params[:itdcon_id])
    redirect_to root_path, notice: "Acción invalida." if !@itdcon
  end

  def get_empresa
    @empresa = Empresa.find_by(id: params[:empresa_id])
    redirect_to root_path, notice: "Acción invalida." if !@empresa
  end

  def get_itdind
    @itdind = Itdind.find_by(id: params[:id])
    redirect_to root_path, notice: "Acción invalida." if !@itdind
  end

  def update_verificators
    Verificador.all.each do |verificador|
      state = @parameters[:com_verificadors_atributtes]["ver"+verificador.id.to_s]
      comment = @parameters[:com_verificadors_atributtes]["comment_"+verificador.id.to_s]
      if state != "0" and comment != ""
        @verificador = ComVerificador.find_by(itdind_id: @itdind.id, verificador_id: verificador.id)
        if @verificador
          @verificador.update({state: state, comment: comment})
        else
          @verificador = ComVerificador.new({state: state, comment: comment})
          @verificador.itdind = @itdind
          @verificador.verificador_id = verificador.id
          @verificador.save
        end
      end
    end
  end

  def itdind_params
    permited = []
    permited_ver = []
    Driver.all.each do |driver|
      permited.push(driver.identifier)
      driver.verificadors.all.each do |verificador|
        permited_ver.push("ver"+verificador.id.to_s)
        permited_ver.push("comment_"+verificador.id.to_s)
      end
    end
    params.require(:itdind).permit([:itdcon_id].concat(permited), com_verificadors_atributtes: [:id].concat(permited_ver))
  end
end
