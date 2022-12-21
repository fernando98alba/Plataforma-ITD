class ItdconsController < ApplicationController
  before_action :get_empresa
  def index
    @itdcons = @empresa.itdcons
  end

  private
  
  def get_empresa
  @empresa = Empresa.find(params[:empresa_id])
end
end
