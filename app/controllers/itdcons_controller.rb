class ItdconsController < ApplicationController
  before_action :set_itd, only: [ :show, :edit, :update, :destroy ]
  before_action :get_itdcon
  before_action :get_empresa
  def index
    @itdcon = @empresa.itdcons
  end
  def create
    @itdcon = @empresa.itdcons.build()
    #respond_to do |format|
    if @itdcon.save
      redirect_to new_empresa_itdcon_itdind_path(@empresa.id, @itdcon.id)
    else #REVISAR EL ELSE
      redirect_to new_empresa_itdcon_path(@empresa.id)
    end
    #end
  end

  private
  def get_itdcon
    @itdcon = Itdcon.find_by(id: params[:id])
  end
  def get_empresa
    @empresa = Empresa.find_by(id:params[:empresa_id])
  end
end
