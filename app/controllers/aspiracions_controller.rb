class AspiracionsController < ApplicationController
  before_action :get_aspiracion, only: [ :index, :show, :edit, :update, :destroy ]
  before_action :get_empresa
  before_action :get_last_itdcon, only: [ :index, :create ]
  before_action :get_recomendation, only: [:index, :create ]
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
        format.html { redirect_to new_empresa_aspiracion_path(@empresa.id), status: :unprocessable_entity }
        format.json { render json: @aspiracion.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def get_recomendation
    @recomendation = {}
    get_points
    @points_dat.keys.each do |dat|
      if @points_dat[dat] < @itdcon.maturity
        @recomendation[dat.downcase.gsub("é", "e")] = @itdcon.maturity - @points_dat[dat]
      else
        @recomendation[dat.downcase.gsub("é", "e")] = 0
      end
    end
  end

  def update_recomendation
    print @recomendation
    puts
    puts
    print "NEW"
    puts
    puts

    @points_dat.keys.each do |dat|
      if aspiracion_params[dat.downcase.gsub("é", "e")] != ""
        @recomendation[dat.downcase.gsub("é", "e")] = aspiracion_params[dat.downcase.gsub("é", "e")].to_i
      else
        @recomendation[dat.downcase.gsub("é", "e")] = @recomendation[dat.downcase.gsub("é", "e")].to_i
      end
    end
    puts @recomendation
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

  def aspiracion_params
    #:maturity_score, :alignment_score, , :estrategia, :modelonegocios, :governance, :procesos, :tecnologia, :datosyalanitica, :modelooperativo, :propiedadintelectual, :personas, :ciclodevida, :estructura, :stakejolderts, :marca, :clientes, :sustentabilidad
    params.require(:aspiracion).permit(:estrategico, :estructural, :humano, :relacional, :natural, :empresa_id)
  end

  def get_points ##DRYS
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
end