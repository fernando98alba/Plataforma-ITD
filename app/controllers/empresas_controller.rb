class EmpresasController < ApplicationController
  before_action :set_empresa, only: [ :show, :edit, :update, :destroy ]
  before_action :authenticate_user!
  before_action :correct_user, only: [ :edit, :update, :destroy ]
  before_action :correct_user_show, only: [ :show]
  before_action :correct_user_new, only: [ :new]
  def index
    @empresas = Empresa.all
  end

  def new
    @empresa = Empresa.new
    #@empresa = current_user.empresas.build
  end

  def edit
  end

  def create
    @empresa = Empresa.new(empresa_params)
    
    respond_to do |format|
      if @empresa.save

        current_user.empresa_id = @empresa.id
        current_user.is_admin = 1
        current_user.save
        format.html { redirect_to empresa_url(@empresa), notice: "Empresa creada con éxito." }
        format.json { render :show, status: :created, location: @empresa }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @empresa.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy

    if current_user.empresa_id == @empresa.id and current_user.is_admin
        @empresa.destroy
        respond_to do |format|
          redirect_to root_path, notice: "Empresa eliminada con éxito."
          format.json { head :no_content }
        end 
    else
        respond_to do |format|
          redirect_to empresa_path @empresa, notice: "No tienes permiso."
        end
    end
  end
  
  def show
  end

  private

  def correct_user_show
    redirect_to root_path, notice: "No tienes permiso realizar esa acción." if @empresa != current_user.empresa
  end

  def correct_user_new
    redirect_to root_path, notice: "Ya eres miembro de una empresa." if current_user.empresa
  end

  def correct_user
    redirect_to root_path, notice: "No tienes permiso realizar esa acción." if !(@empresa == current_user.empresa and current_user.is_admin)
  end

  def set_empresa
    @empresa = Empresa.find_by(id: params[:id])
    redirect_to root_path, notice: "Acción inválida." if !@empresa
  end

  def empresa_params
    params.require(:empresa).permit(:name, :rut, :sector, :size)
  end
end
