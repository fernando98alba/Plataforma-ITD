class EmpresasController < ApplicationController
  before_action :set_empresa, only: [ :show]
  before_action :authenticate_user!
  before_action :correct_user, only: [ :show]
  
  def show
  end

  private

  def correct_user
    redirect_to root_path, notice: "No tienes permiso realizar esa acción." if @empresa != current_user.empresa
  end

  def set_empresa
    @empresa = Empresa.find_by(id: params[:id])
    redirect_to root_path, notice: "Acción inválida." if !@empresa
  end

end
