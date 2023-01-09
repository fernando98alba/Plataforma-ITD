class AspiracionsController < ApplicationController
  before_action :get_empresa
  before_action :get_aspiracion, only: [ :index, :show, :edit, :update, :destroy ]
  before_action :get_last_itdcon, only: [ :index, :show, :create, :update_maturity_recomendation, :update_dat_recomendation, :update_hab_recomendation  ]
  before_action :get_recomendation, only: [:index, :create]
  respond_to :js, :json, :html

  def new
    @aspiracion = @empresa.aspiracion.build()
  end
  def index
  end

  def show
    @itdcons = @empresa.itdcons.all
    get_points

  end

  def create
    puts
    puts
    puts "AAAAAA"
    puts aspiracion_params
    @aspiracion = Aspiracion.new(aspiracion_params)
    
    respond_to do |format|
      if @aspiracion.save
        format.html { redirect_to root_path, notice: "Aspiracion was successfully created." }
      else
        format.html { redirect_to empresa_aspiracions_path(@empresa.id), status: :unprocessable_entity }
        format.json { render json: @aspiracion.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_maturity_recomendation
    @recomendation_mat = {}
    @recomendation_dat = {}
    @recomendation_hab = {}
    @aspiracion_dat = {}
    @aspiracion_mat = {}
    @aspiracion_hab = {}
    maturity_params.keys.each do |mat|
      if maturity_params[mat] != "" and maturity_params[mat] != nil
        @recomendation_mat[mat] = maturity_params[mat].to_f
      else
        puts
        @recomendation_mat[mat] = @itdcon[mat]
      end
    end
    @aspiracion_mat = @recomendation_mat
    get_points
    calculate_recomendation

    respond_to do |format|
      format.turbo_stream
    end
  end

  def update_dat_recomendation
    get_points
    @recomendation_mat = {}
    @recomendation_mat["alignment_score"] = dat_params["alignment_score"].to_i
    @recomendation_mat["maturity_score"] = dat_params["maturity_score"].to_i
    @recomendation_dat = {}
    calculate_recomendation
    @aspiracion_dat = {}
    @aspiracion_mat = {}
    @aspiracion_hab = {}
    @recomendation_hab = {}
    puts @points_dat
    @points_dat.keys.each do |dat|
      if dat_params[dat] != "" and dat_params[dat] != nil
        @aspiracion_dat[dat] = dat_params[dat].to_f
      else
        @aspiracion_dat[dat] = @points_dat[dat]
      end
    end
    puts @aspiracion_dat
    @aspiracion_dat.keys.each do |dat|
      if @aspiracion_dat[dat] < @points_dat[dat]
        @aspiracion_dat[dat] = @points_dat[dat] #SHOW ERROR (?)
      end
    end
    @aspiracion_mat["alignment_score"] = 0
    @aspiracion_mat["maturity_score"] = 0
    
    Dat.all.each do |dat|
      @aspiracion_mat["maturity_score"] += @aspiracion_dat[dat.name.downcase]*dat.ponderador
    end
    calculate_hab_recomendation

    respond_to do |format|
      format.html { redirect_to root_path, notice: "Aspiracion was successfully created." }
      format.turbo_stream
    end
  end

  def update_hab_recomendation
    get_points
    @aspiracion_mat = {}
    @aspiracion_dat = {}
    @aspiracion_hab = {}
    @recomendation_hab = {}
    habilitadores = []
    
    @points_dat.keys.each do |dat|
      @aspiracion_dat[dat] = hab_params[dat].to_f 
    end
    @aspiracion_mat["alignment_score"] = 0
    @aspiracion_mat["maturity_score"] = 0
    calculate_hab_recomendation

    @points_hab.keys.each do |dat|
      if dat == hab_params[:dat]
        @aspiracion_dat[dat] = 0
        @aspiracion_hab[dat] = {}
        @points_hab[dat].keys.each do |hab|
          if hab_params[hab] != "" and hab_params[hab] != nil
            @aspiracion_hab[dat][hab] = hab_params[hab].to_f
          else
            @aspiracion_hab[dat][hab] = @points_hab[dat][hab]
          end
          print "#{@aspiracion_hab[dat][hab]} #{@points_hab[dat][hab]} #{dat} #{hab}\n\n"
          if @aspiracion_hab[dat][hab] < @points_hab[dat][hab]
            @aspiracion_hab[dat][hab] = @points_hab[dat][hab]
          end
          habilitadores.push @aspiracion_hab[dat][hab]
          @aspiracion_dat[dat] += @aspiracion_hab[dat][hab]/@points_hab[dat].keys.size
        end
      else
        @points_hab[dat].keys.each do |hab|
          if hab_params[hab] != "" and hab_params[hab] != nil
            if !@aspiracion_hab.keys.include? dat
              @aspiracion_dat[dat] = 0
              @aspiracion_hab[dat] = {}
            end
            @aspiracion_hab[dat][hab] = hab_params[hab].to_f
            habilitadores.push @aspiracion_hab[dat][hab]
            @aspiracion_dat[dat] += @aspiracion_hab[dat][hab]/@points_hab[dat].keys.size
          else
            habilitadores.push @recomendation_hab[dat][hab]
          end
        end
      end
    end
    puts @aspiracion_dat
    puts @aspiracion_hab
    @aspiracion_mat["alignment_score"] = 0
    
    Dat.all.each do |dat|
      @aspiracion_mat["maturity_score"] += @aspiracion_dat[dat.name.downcase]*dat.ponderador
    end

    alignment_mean = habilitadores.sum(0.0)/habilitadores.size
    num_sum = habilitadores.sum(0.0) {|element| (element - alignment_mean) ** 2}
    variance = num_sum / (habilitadores.size)  
    @aspiracion_mat["alignment_score"] = Math.sqrt(variance)

    respond_to do |format|
      format.html { redirect_to root_path, notice: "Aspiracion was successfully created." }
      format.turbo_stream
    end
  end

  private
  def calculate_recomendation
    recomendation_sorted = @points_dat.sort_by{|k, v| v}
    list = {}
    recomendation_sorted.each do |element|
      list[element[0]] = element[1]
    end
    ponderators = {}
    keys = list.keys

    Dat.all.each do |dat|
      ponderators[dat.name.downcase] = dat.ponderador
    end
    madurez = @itdcon["maturity_score"]
    ptos = (@recomendation_mat["maturity_score"] - madurez)/ponderators[keys[0]]
    while ptos.to_i > 0
      madurez = 0
      keys.each do |key|
        madurez += list[key]*ponderators[key]
      end
      diff = 0 #la diferencia entre un habilitador y el siguiente
      list_aux = [] #habilitadores a subir puntaje
      (0...keys.length-1).each do |key|
        list_aux << keys[key]
        if list[keys[key]] < list[keys[key + 1]]
          diff = list[keys[key + 1]] -  list[keys[key]]
          break
        end
      end
      if diff == 0 #caso en que todos los habilitadores están con el mismo puntaje
        ptos = keys.length*(@recomendation_mat["maturity_score"] - madurez)
        resta = (ptos/keys.length).floor #cantidad a subir por habilitador (es el piso para que sea entero y no sume más de la cuenta)
        keys.each do |key|
          list[key] += resta
          ptos -= resta
        end
        if ptos > 0
          keys.each do |key|
            list[key] += 1
            ptos -= 1
            if ptos == 0
              break
            end
          end
        end
      else
        if list_aux.length > 1
          avrg_ponderator = 0
          list_aux.each do |key|
            avrg_ponderator += ponderators[key]
          end
          avrg_ponderator = avrg_ponderator/list_aux.length 
          ptos = (@recomendation_mat["maturity_score"] - madurez)/avrg_ponderator
        end
        if diff*list_aux.length <= ptos
          list_aux.each do |key|
            list[key] += diff
          end
          ptos -= diff*list_aux.length
        else
          resta = (ptos/keys.length).floor
          list_aux.each do |key|
            list[key] += resta
            ptos -= resta
          end
          if ptos > 0
            list_aux.each do |key|
              list[key] += 1
              ptos -= 1
              if ptos == 0
                break
              end
            end
          end
        end
      end
    end
    @recomendation_dat = list
  end

  def calculate_hab_recomendation
    habilitadores = []
    @aspiracion_dat.keys.each do |dat|
      recomendation_sorted = @points_hab[dat].sort_by{|k, v| v}
      list = {}
      recomendation_sorted.each do |element|
        list[element[0]] = element[1]
      end
      keys = list.keys
      ptos = (@aspiracion_dat[dat] - @points_dat[dat])*@points_hab[dat].keys.length

      while ptos >0
        diff = 0 #la diferencia entre un habilitador y el siguiente
        list_aux = [] #habilitadores a subir puntaje
        (0...keys.length-1).each do |key|
          list_aux << keys[key]
          if list[keys[key]] < list[keys[key + 1]]
            diff = list[keys[key + 1]] -  list[keys[key]]
            break
          end
        end
        if diff == 0 #caso en que todos los habilitadores están con el mismo puntaje
          resta = (ptos/keys.length).floor #cantidad a subir por habilitador (es el piso para que sea entero y no sume más de la cuenta)
          keys.each do |key|
            list[key] += resta
            ptos -= resta
          end
          if ptos > 0
            keys.each do |key|
              list[key] += 1
              ptos -= 1
              if ptos == 0
                break
              end
            end
          end
        else
          if diff*list_aux.length <= ptos
            list_aux.each do |key|
              list[key] += diff
            end
            ptos -= diff*list_aux.length
          else
            resta = (ptos/keys.length).floor
            list_aux.each do |key|
              list[key] += resta
              ptos -= resta
            end
            if ptos > 0
              list_aux.each do |key|
                list[key] += 1
                ptos -= 1
                if ptos == 0
                  break
                end
              end
            end
          end
        end
      end
      @recomendation_hab[dat] = list
      list.keys.each do |key|
        habilitadores.push list[key]
      end
    end
    alignment_mean = habilitadores.sum(0.0)/habilitadores.size
    num_sum = habilitadores.sum(0.0) {|element| (element - alignment_mean) ** 2}
    variance = num_sum / (habilitadores.size)  
    @aspiracion_mat["alignment_score"] = Math.sqrt(variance)
  end
  def get_recomendation
    @recomendation_mat = {}
    @recomendation_dat = {}
    @recomendation_hab = {}
    @points_dat = {}
    @points_hab = {}
    @aspiracion_dat = {}
    @aspiracion_mat = {}
    @aspiracion_hab = {}
    @recomendation_mat["maturity_score"] = 0
    @recomendation_mat["alignment_score"] = 0
  end

  def get_aspiracion
    @aspiracion = @empresa.aspiracion.last
  end

  def get_empresa

    @empresa = Empresa.find_by(id: params[:empresa_id])
  end

  def get_last_itdcon
    @itdcon = @empresa.itdcons.last
  end

  def maturity_params

    #:maturity_score, :alignment_score, , :estrategia, :modelonegocios, :governance, :procesos, :tecnologia, :datosyalanitica, :modelooperativo, :propiedadintelectual, :personas, :ciclodevida, :estructura, :stakejolderts, :marca, :clientes, :sustentabilidad
    params.require(:aspiracion).permit(:maturity_score, :alignment_score)
  end

  def dat_params
    #:maturity_score, :alignment_score, , :estrategia, :modelonegocios, :governance, :procesos, :tecnologia, :datosyalanitica, :modelooperativo, :propiedadintelectual, :personas, :ciclodevida, :estructura, :stakejolderts, :marca, :clientes, :sustentabilidad
    params.require(:aspiracion).permit(:estrategico, :estructural, :humano, :relacional, :natural, :maturity_score, :alignment_score)
  end

  def hab_params
    #:maturity_score, :alignment_score, , :estrategia, :modelonegocios, :governance, :procesos, :tecnologia, :datosyalanitica, :modelooperativo, :propiedadintelectual, :personas, :ciclodevida, :estructura, :stakejolderts, :marca, :clientes, :sustentabilidad
    params.require(:aspiracion).permit(:dat, :estrategia, :modelosdenegocios, :governance, :procesos, :tecnología, :datosyanalítica, :modelooperativo, :propiedadintelectual, :personas, :ciclodevidadelcolaborador, :estructuraorganizacional, :stakeholders, :marca, :clientes, :sustentabilidad, :estrategico, :estructural, :humano, :relacional, :natural,)
  end

  def aspiracion_params
    #:maturity_score, :alignment_score, , :estrategia, :modelonegocios, :governance, :procesos, :tecnologia, :datosyalanitica, :modelooperativo, :propiedadintelectual, :personas, :ciclodevida, :estructura, :stakejolderts, :marca, :clientes, :sustentabilidad
    params.require(:aspiracion).permit(:estrategico, :estructural, :humano, :relacional, :natural, :empresa_id, :maturity_score, :alignment_score, :estrategia, :modelosdenegocios, :governance, :procesos, :tecnología, :datosyanalítica, :modelooperativo, :propiedadintelectual, :personas, :ciclodevidadelcolaborador, :estructuraorganizacional, :stakeholders, :marca, :clientes, :sustentabilidad)
  end

  def get_points ##DRYS
    @points_dat = {}
    @points_hab = {}
    Dat.all.each do |dat|
      point_dat = 0
      @points_hab[dat.name.downcase] = {}
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
        @points_hab[dat.name.downcase][habilitador.name.downcase.gsub(" ", "")] = point_habilitador
        point_dat += point_habilitador
      end
      point_dat = point_dat/dat.habilitadors.count.to_f
      @points_dat[dat.name.downcase] = point_dat
    end
  end
end