class AspiracionsController < ApplicationController
  before_action :get_aspiracion, only: [ :index, :show, :edit, :update, :destroy ]
  before_action :get_empresa
  before_action :get_last_itdcon, only: [ :index, :create, :update_maturity_recomendation, :update_dat_recomendation, :update_hab_recomendation  ]
  before_action :get_recomendation, only: [:index, :create]
  respond_to :js, :json, :html

  def new
    @aspiracion = @empresa.aspiracion.build()
  end
  def index
  end

  def create
    @aspiracion = Aspiracion.new(aspiracion_params)
    update_recomendation
    respond_to do |format|
      if @aspiracion.save
        format.html { redirect_to root_path, notice: "Aspiracion was successfully created." }
        format.turbo_stream
      else
        format.html { redirect_to empresa_aspiracions_path(@empresa.id), status: :unprocessable_entity }
        format.json { render json: @aspiracion.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_maturity_recomendation
    puts params
    puts maturity_params
    puts
    @recomendation_mat = {}
    @recomendation_dat = {}
    @recomendation_hab = {}
    maturity_params.keys.each do |mat|
      if maturity_params[mat] != "" and maturity_params[mat] != nil
        @recomendation_mat[mat] = maturity_params[mat].to_f
      else
        puts
        @recomendation_mat[mat] = @itdcon[mat.gsub("_score", "")]
      end
    end
    get_points
    calculate_recomendation

    respond_to do |format|
      format.turbo_stream
    end
  end

  def update_dat_recomendation
    get_points
    @recomendation_mat = {}
    @recomendation_dat = {}
    @recomendation_hab = {}
    dat_params.keys.each do |dat|
      if dat_params[dat] != "" and dat_params[dat] != nil
        @recomendation_dat[dat] = dat_params[dat].to_f
      else
        @recomendation_dat[dat] = @points_dat[dat]
      end
    end
    @recomendation_dat.keys.each do |dat|
      if @recomendation_dat[dat] < @points_dat[dat]
        @recomendation_dat[dat] = @points_dat[dat] #SHOW ERROR (?)
      end
    end
    @recomendation_mat["alignment_score"] = 0
    @recomendation_mat["maturity_score"] = 0
    Dat.all.each do |dat|
      @recomendation_mat["maturity_score"] += @recomendation_dat[dat.name.downcase.gsub("é", "e")]*dat.ponderador
    end
    calculate_hab_recomendation
    respond_to do |format|
      format.html { redirect_to root_path, notice: "Aspiracion was successfully created." }
      format.turbo_stream
    end
  end

  def update_hab_recomendation
    get_points
    @recomendation_mat = {}
    @recomendation_dat = {}
    @recomendation_hab = {}
    dat_params.keys.each do |dat|
      if dat_params[dat] != "" and dat_params[dat] != nil
        @recomendation_dat[dat] = dat_params[dat].to_f
      else
        @recomendation_dat[dat] = @points_dat[dat]
      end
    end
    @recomendation_dat.keys.each do |dat|
      if @recomendation_dat[dat] < @points_dat[dat]
        calculate_recomendation
      end
    end
    @recomendation_mat["alignment_score"] = 0
    @recomendation_mat["maturity_score"] = 0
    Dat.all.each do |dat|
      @recomendation_mat["maturity_score"] += @recomendation_dat[dat.name.downcase.gsub("é", "e")]*dat.ponderador
    end
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
      ponderators[dat.name.downcase.gsub("é", "e")] = dat.ponderador
    end
    madurez = @itdcon["maturity"]
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
    @recomendation_dat.keys.each do |dat|
      recomendation_sorted = @points_hab[dat].sort_by{|k, v| v}
      list = {}
      recomendation_sorted.each do |element|
        list[element[0]] = element[1]
      end
      keys = list.keys
      ptos = (@recomendation_dat[dat] - @points_dat[dat])*@points_hab[dat].keys.length

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
    end
    puts
    puts
    puts @recoemndation_hab
  end
  def get_recomendation
    @recomendation_mat = {}
    @recomendation_dat = {}
    @recomendation_hab = {}
    @points_dat = {}
    @points_hab = {}
    @recomendation_mat["maturity_score"] = 0
    @recomendation_mat["alignment_score"] = 0
  end

  def get_aspiracion
    @aspiracion = Aspiracion.find_by(id: params[:id])
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
    params.require(:aspiracion).permit(:estrategico, :estructural, :humano, :relacional, :natural)
  end

  def aspiracion_params
    #:maturity_score, :alignment_score, , :estrategia, :modelonegocios, :governance, :procesos, :tecnologia, :datosyalanitica, :modelooperativo, :propiedadintelectual, :personas, :ciclodevida, :estructura, :stakejolderts, :marca, :clientes, :sustentabilidad
    params.require(:aspiracion).permit(:estrategico, :estructural, :humano, :relacional, :natural, :empresa_id, :maturity_score, :alignment_score)
  end

  def get_points ##DRYS
    @points_dat = {}
    @points_hab = {}
    Dat.all.each do |dat|
      point_dat = 0
      @points_hab[dat.name.downcase.gsub("é", "e")] = {}
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
        @points_hab[dat.name.downcase.gsub("é", "e")][habilitador.name.downcase] = point_habilitador
        point_dat += point_habilitador
      end
      point_dat = point_dat/dat.habilitadors.count.to_f
      @points_dat[dat.name.downcase.gsub("é", "e")] = point_dat
    end
  end
end