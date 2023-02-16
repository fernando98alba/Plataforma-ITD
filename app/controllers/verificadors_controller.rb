class VerificadorsController < ApplicationController
  before_action :get_verificador,  only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  
  def edit
  end
  def update 
    @verificador.update(verificador_params)
  end
  private
  def get_verificador
    @verificador = Verificador.find_by(id: params[:id])
  end
  def verificador_params
    permited = []
    Driver.all.each do |driver|
      permited.push(driver.identifier)
    end
    params.require(:verificador).permit(permited)
  end
end
