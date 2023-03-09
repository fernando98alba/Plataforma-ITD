class ComVerificadorsController < ApplicationController
  before_action :get_itdcon
  before_action :get_empresa
  before_action :authenticate_user!
  before_action :correct_empresa_itdcon
  before_action :correct_user
  before_action :get_points, only: [ :show]
  before_action :correct_completed
  def index
    @results_ver = {}
    itdind_ids = @itdcon.itdind_ids
    Dat.all.each do |dat|
      @results_ver[dat.name.downcase] = {}
      dat.habilitadors.each do |hab|
        @results_ver[dat.name.downcase][hab.name.downcase] = {}
        hab.elementos.each do |ele|
          ele.drivers.each do |dri|
            dri.verificadors.each do |ver|
              ver.com_verificadors.where(itdind_id: itdind_ids).each do |com_verificador|
                if com_verificador.state != 0
                  if !@results_ver[dat.name.downcase][hab.name.downcase].keys.include? com_verificador.verificador.name
                    @results_ver[dat.name.downcase][hab.name.downcase][com_verificador.verificador.name] = {results: [], value: 0.0}
                  end
                  @results_ver[dat.name.downcase][hab.name.downcase][com_verificador.verificador.name][:results].push com_verificador[:state] -1
                  @results_ver[dat.name.downcase][hab.name.downcase][com_verificador.verificador.name][:value] += com_verificador[:state] -1
                end
              end
            end
          end
        end
        if @results_ver[dat.name.downcase][hab.name.downcase].keys.length == 0
          @results_ver[dat.name.downcase].delete(hab.name.downcase)
        end
      end
      if @results_ver[dat.name.downcase].keys.length == 0
        @results_ver.delete(hab.name.downcase)
      end
    end
    @results_dat = {}
    @results_hab = {}
    @results_general = {green: 0, gray: 0, red: 0}
    @results_ver.keys.each do |dat|
      @results_dat[dat] = {green: 0.0, gray: 0.0, red: 0.0, total: 0}
      @results_hab[dat] = {}
      @results_ver[dat].keys.each do |hab|
        @results_hab[dat][hab] = {green: 0.0, gray: 0.0, red: 0.0, total: 0}
        @results_ver[dat][hab].keys.each do |key|
          if @results_ver[dat][hab][key][:results].length >0
            @results_ver[dat][hab][key][:value] = @results_ver[dat][hab][key][:value]/ @results_ver[dat][hab][key][:results].length
            @results_dat[dat][:total] +=1
            @results_hab[dat][hab][:total] += 1
            if @results_ver[dat][hab][key][:value] >=0.75
              @results_dat[dat][:green] +=1
              @results_hab[dat][hab][:green] +=1
              @results_general[:green] +=1
            elsif @results_ver[dat][hab][key][:value] >=0.4
              @results_dat[dat][:gray] +=1
              @results_hab[dat][hab][:gray] +=1
              @results_general[:gray] +=1
            else
              @results_dat[dat][:red] +=1
              @results_hab[dat][hab][:red] +=1
              @results_general[:red] +=1
            end
          end
        end
      end
    end
    puts @results_hab
    puts "AAA"
    puts @results_dat
    puts "BBB"
    puts @results_general
  end

  private
  def get_empresa
    @empresa = Empresa.find(params[:empresa_id])
  end
  def get_itdcon
    @itdcon = Itdcon.find(params[:itdcon_id])
  end
  def correct_completed
    redirect_to empresa_itdcons_url(@empresa), notice: "Todos deben responder la encuesta antes de ver los resultados." if (!@itdcon.completed)
  end
  def correct_empresa_itdcon
    redirect_to root_path, notice: "No tienes permiso realizar esa acción." if !(@itdcon.empresa == @empresa)
  end
  def correct_user
    redirect_to root_path, notice: "No tienes permiso realizar esa acción." if !(current_user.empresa == @empresa)
  end
end
