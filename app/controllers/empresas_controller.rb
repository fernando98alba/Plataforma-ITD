class EmpresasController < ApplicationController
  before_action :set_empresa, only: [ :show, :edit, :update, :destroy ]
  before_action :authenticate_user!, exept: [:index, :show]
  #before_action :correct_user, only: [:edit, :update, :show, :destroy]
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
        format.html { redirect_to root_path, notice: "Empresa was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy

    if current_user.empresa_id == @empresa.id and current_user.is_admin
        @empresa.destroy
        respond_to do |format|
          redirect_to root_path, notice: "Empresa was successfully destroyed."
        end 
    else
        respond_to do |format|
          redirect_to empresa_path @empresa, notice: "No tienes permiso."
        end
    end
  end
  
  def show
    
  end

  #def correct_user
   # empresaid = @empresa.id
    #@verificador = current_user.empresa_id == empresaid
    #redirect_to empresas_path, notice: "No tienes permiso realizar esa acción." if !@verificador

  #end

  private

  def set_empresa
    @empresa = Empresa.find(params[:id])
  end

  def empresa_params
    params.require(:empresa).permit(:name, :rut, :sector, :income)
  end
end
