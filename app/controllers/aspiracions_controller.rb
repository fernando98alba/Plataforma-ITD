class AspiracionsController < ApplicationController
  before_action :get_empresa
  before_action :authenticate_user!
  before_action :get_aspiracion, only: [ :show, :destroy ]
  before_action :get_last_itdcon, only: [ :index, :show, :create, :update_maturity_recomendation, :update_dat_recomendation, :update_hab_recomendation  ]
  before_action :get_recomendation, only: [:index, :create]
  respond_to :js, :json, :html
  before_action :correct_user
  before_action :correct_admin, only: [:index]
  before_action :correct_empresa, only: [:show]

  def new
    @aspiracion = @empresa.aspiracion.build()
  end

  def index
  end

  def show
    @itdcons = @empresa.itdcons.all
    get_points #get element and driver points and recomendations
    @recomendation_element = {}
    @recomendation_driver = {}
    calculate_element_driver_recomendation
  end

  def create
    @last_aspiracion = @empresa.aspiracion.last
    @aspiracion = Aspiracion.new(aspiracion_params)
    
    respond_to do |format|
      if @aspiracion.save
        if @last_aspiracion
          @last_aspiracion.delete
        end
        format.html { redirect_to empresa_aspiracion_path(@empresa, @aspiracion), notice: "Aspiración creada con éxito." }
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
    @recomendation_mat["alignment_score"] = dat_params["alignment_score"].to_f
    @recomendation_mat["maturity_score"] = dat_params["maturity_score"].to_f
    @recomendation_dat = {}
    calculate_recomendation
    @aspiracion_dat = {}
    @aspiracion_mat = {}
    @aspiracion_hab = {}
    @recomendation_hab = {}
    @points_dat.keys.each do |dat|
      if dat_params[dat] != "" and dat_params[dat] != nil
        @aspiracion_dat[dat] = dat_params[dat].to_f
      else
        @aspiracion_dat[dat] = @points_dat[dat]
      end
    end
    if @aspiracion_dat == @points_dat
      @aspiracion_dat = @recomendation_dat
    end
    @aspiracion_mat["alignment_score"] = 0
    @aspiracion_mat["maturity_score"] = 0
    Dat.all.each do |dat|
      @aspiracion_mat["maturity_score"] += @aspiracion_dat[dat.name.downcase.downcase]*dat.ponderador
    end
    calculate_hab_recomendation
    puts "habbb"
    puts @aspiracion_dat
    puts @recomendation_hab
    if @aspiracion_dat == @points_dat
      @recomendation_hab = {}
      @aspiracion_dat = {}
    end

    respond_to do |format|
      format.html { redirect_to root_path, notice: "Aspiración creada con éxito." }
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
    @recomendation_mat = {}
    @recomendation_mat["alignment_score"] = hab_params["alignment_score"].to_f
    @recomendation_mat["maturity_score"] = hab_params["maturity_score"].to_f
    @recomendation_dat = {}
    calculate_recomendation
    @points_dat.keys.each do |dat|
      @aspiracion_dat[dat] = hab_params[dat].to_f 
    end
    puts "@aspiracion_dat"
    puts @aspiracion_dat
    @aspiracion_mat["alignment_score"] = 0
    @aspiracion_mat["maturity_score"] = 0
    calculate_hab_recomendation
    puts "@recomendation_hab"
    puts @recomendation_hab
    @points_hab.keys.each do |dat|
      if dat == hab_params[:dat]
        @aspiracion_dat[dat] = 0
        @aspiracion_hab[dat] = {}
        @points_hab[dat].keys.each do |hab|
          if hab_params[hab] != "" and hab_params[hab] != nil
            @aspiracion_hab[dat][hab] = hab_params[hab].to_f
          else
            @aspiracion_hab[dat][hab] = @points_hab[dat][hab].to_f
          end

          habilitadores.push @aspiracion_hab[dat][hab]
          @aspiracion_dat[dat] += @aspiracion_hab[dat][hab]/@points_hab[dat].keys.size
        end
        if @aspiracion_hab[dat] == @points_hab[dat]
          @aspiracion_hab[dat] = @recomendation_hab[dat] 
          @aspiracion_dat[dat] = hab_params[dat].to_f 
          puts "@aspiracion_dat[dat]"
          puts @aspiracion_dat[dat]
          puts dat
          puts @points_hab
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
            @aspiracion_dat[dat] += (@aspiracion_hab[dat][hab].to_f/@points_hab[dat].keys.size).round
          else
            habilitadores.push @recomendation_hab[dat][hab]
          end
        end
      end
    end
    @aspiracion_mat["alignment_score"] = 0
    
    Dat.all.each do |dat|
      @aspiracion_mat["maturity_score"] += @aspiracion_dat[dat.name.downcase.downcase]*dat.ponderador
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

  def correct_user
    redirect_to root_path, notice: "No tienes permiso realizar esa acción." if @empresa != current_user.empresa
  end

  def correct_empresa
    redirect_to root_path, notice: "No tienes permiso realizar esa acción." if @empresa != @aspiracion.empresa
  end

  def correct_admin
    redirect_to root_path, notice: "No tienes permiso realizar definir una aspiración." if !current_user.is_admin
  end

  def calculate_recomendation
    recomendation_sorted = @points_dat.sort_by{|k, v| v}
    list = {}
    recomendation_sorted.each do |element|
      list[element[0]] = element[1]
    end
    ponderators = {}
    keys = list.keys

    Dat.all.each do |dat|
      ponderators[dat.name.downcase.downcase] = dat.ponderador
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
      while ptos.to_i >0
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

  def calculate_element_driver_recomendation
    @points_ele.keys.each do |dat|
      @points_ele[dat].keys.each do |hab|
        recomendation_sorted = @points_ele[dat][hab].sort_by{|k, v| v}
        list = {}
        recomendation_sorted.each do |element|
          list[element[0]] = element[1]
        end
        keys = list.keys
        ptos = (@aspiracion[hab].round(4) - @points_hab[dat][hab].round(4))*@points_ele[dat][hab].keys.length
        puts "AAAAAA"
        puts ptos
        puts @aspiracion[hab]
        puts @points_hab[dat][hab]
        puts hab
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
        @recomendation_element[hab] = list
      end
    end
    puts @recomendation_element
    @points_dri = {}
    Dat.all.each do |dat|
      @recomendation_driver[dat.name.downcase.downcase] = {}
      @points_dri[dat.name.downcase.downcase] = {}
      dat.habilitadors.all.each do |hab|
        @points_dri[dat.name.downcase.downcase][hab.name.downcase.downcase.gsub(" ", "_")] = {}
        @recomendation_driver[dat.name.downcase.downcase][hab.name.downcase.downcase.gsub(" ", "_")] = {}
        hab.elementos.all.each do |ele|
          @points_dri[dat.name.downcase.downcase][hab.name.downcase.downcase.gsub(" ", "_")][ele.name.downcase.downcase.gsub(" ", "_")] = {}
          ele.drivers.all.each do |driver|
            @points_dri[dat.name.downcase.downcase][hab.name.downcase.downcase.gsub(" ", "_")][ele.name.downcase.downcase.gsub(" ", "_")][driver.identifier] = @itdcon[driver.identifier]
          end
          recomendation_sorted = @points_dri[dat.name.downcase.downcase][hab.name.downcase.downcase.gsub(" ", "_")][ele.name.downcase.downcase.gsub(" ", "_")].sort_by{|k, v| v}
          list = {}
          recomendation_sorted.each do |element|
            list[element[0]] = element[1]
          end
          keys = list.keys
          ptos = (@recomendation_element[hab.name.downcase.downcase.gsub(" ", "_")][ele.name.downcase.downcase.gsub(" ", "_")] - @points_ele[dat.name.downcase][hab.name.downcase.gsub(" ", "_")][ele.name.downcase.gsub(" ", "_")])*@points_dri[dat.name.downcase][hab.name.downcase.gsub(" ", "_")][ele.name.downcase.gsub(" ", "_")].keys.length
          ptos = ptos*4.to_f/100
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
              resta = (ptos/keys.length) # ESTO ES LO QUE HAY Q VER SI QUIERO Q SEAN ENTEROS cantidad a subir por habilitador (es el piso para que sea entero y no sume más de la cuenta) 
              keys.each do |key| 
                list[key] += resta
                ptos -= resta
              end
              
            else

              if diff*list_aux.length <= ptos
                list_aux.each do |key|
                  list[key] += diff
                end
                ptos -= diff*list_aux.length
              else
                resta = (ptos/keys.length)
                list_aux.each do |key|
                  list[key] += resta
                  ptos -= resta
                end
                
              end
            end
          end

          @recomendation_driver[dat.name.downcase][hab.name.downcase.gsub(" ", "_")][ele.name.downcase.gsub(" ", "_")] = list
        end
      end
    end
    puts @recomendation_driver
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
    @aspiracion_mat["maturity_score"] = 0
    @aspiracion_mat["alignment_score"] = 0
  end

  def get_aspiracion
    @aspiracion = @empresa.aspiracion.last
    redirect_to empresa_aspiracions_path(@empresa), notice: "Acción invalida." if !@aspiracion
  end

  def get_empresa
    @empresa = Empresa.find_by(id: params[:empresa_id])
    redirect_to root_path, notice: "Acción invalida." if !@empresa
  end

  def get_last_itdcon
    @itdcon = @empresa.itdcons.where(completed: true).last
    redirect_to empresa_itdcons_path(@empresa), notice: "Acción invalida." if !@itdcon
  end

  def maturity_params

    #:maturity_score, :alignment_score, , :estrategia, :modelonegocios, :governance, :procesos, :tecnologia, :datosyalanitica, :modelooperativo, :propiedadintelectual, :personas, :ciclodevida, :estructura, :stakejolderts, :marca, :clientes, :sustentabilidad
    params.require(:aspiracion).permit(:maturity_score, :alignment_score)
  end

  def dat_params
    #:maturity_score, :alignment_score, , :estrategia, :modelonegocios, :governance, :procesos, :tecnologia, :datosyalanitica, :modelooperativo, :propiedadintelectual, :personas, :ciclodevida, :estructura, :stakejolderts, :marca, :clientes, :sustentabilidad
    params.require(:aspiracion).permit(:maturity_score, :alignment_score, :estratégico, :estructural, :humano, :relacional, :natural, :maturity_score, :alignment_score)
  end

  def hab_params
    #:maturity_score, :alignment_score, , :estrategia, :modelonegocios, :governance, :procesos, :tecnologia, :datosyalanitica, :modelooperativo, :propiedadintelectual, :personas, :ciclodevida, :estructura, :stakejolderts, :marca, :clientes, :sustentabilidad
    params.require(:aspiracion).permit(:maturity_score, :alignment_score, :dat, :estrategia, :modelos_de_negocios, :governance, :procesos, :tecnología, :datos_y_analítica, :modelo_operativo, :propiedad_intelectual, :personas, :ciclo_de_vida_del_colaborador, :estructura_organizacional, :stakeholders, :marca, :clientes, :sustentabilidad, :estratégico, :estructural, :humano, :relacional, :natural,)
  end

  def aspiracion_params
    #:maturity_score, :alignment_score, , :estrategia, :modelonegocios, :governance, :procesos, :tecnologia, :datosyalanitica, :modelooperativo, :propiedadintelectual, :personas, :ciclodevida, :estructura, :stakejolderts, :marca, :clientes, :sustentabilidad
    params.require(:aspiracion).permit(:estratégico, :estructural, :humano, :relacional, :natural, :empresa_id, :maturity_score, :alignment_score, :estrategia, :modelos_de_negocios, :governance, :procesos, :tecnología, :datos_y_analítica, :modelo_operativo, :propiedad_intelectual, :personas, :ciclo_de_vida_del_colaborador, :estructura_organizacional, :stakeholders, :marca, :clientes, :sustentabilidad)
  end

  def get_points ##DRYS
    @points_dat = {}
    @points_hab = {}
    @points_ele = {}
    Dat.all.each do |dat|
      point_dat = 0
      @points_hab[dat.name.downcase] = {}
      @points_ele[dat.name.downcase.downcase] = {}
      dat.habilitadors.each do |habilitador|
        @points_ele[dat.name.downcase.downcase][habilitador.name.downcase.downcase.gsub(" ", "_")] = {}
        point_habilitador = 0
        habilitador.elementos.each do |elemento|
          point_elemento = 0
          elemento.drivers.each do |driver|
            point_elemento += @itdcon[driver.identifier]
          end
          point_elemento = point_elemento/elemento.drivers.count.to_f
          point_elemento = point_elemento*100/4.to_f
          @points_ele[dat.name.downcase.downcase][habilitador.name.downcase.downcase.gsub(" ", "_")][elemento.name.downcase.downcase.gsub(" ", "_")] = point_elemento
          point_habilitador += point_elemento 
        end
        point_habilitador = point_habilitador/habilitador.elementos.count.to_f
        @points_hab[dat.name.downcase.downcase][habilitador.name.downcase.downcase.gsub(" ", "_")] = point_habilitador
        point_dat += point_habilitador
      end
      point_dat = point_dat/dat.habilitadors.count.to_f
      @points_dat[dat.name.downcase.downcase] = point_dat
    end
  end
end
