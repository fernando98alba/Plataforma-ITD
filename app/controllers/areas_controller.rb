class AreasController < ApplicationController
  before_action :get_empresa
  before_action :authenticate_user!
  before_action :correct_user
  def create
    @parameters = area_params
    puts @parameters
    puts @parameters[:name]!="" ? @parameters[:name] : nil
    @area = @empresa.areas.build(name: @parameters[:name]!="" ? @parameters[:name] : nil)
    if @area.save
      keys = @parameters.keys() - [:name]
      puts keys
      keys.each do |key|
        if @parameters[key].to_i == 1
          puts "Saving"
          user = User.find_by(id: key)
          user.area = @area
          user.save
        end
      end
      redirect_to root_path,  notice: "Área creada."
    else
      redirect_to root_path,  notice: "Error al guardar."
    end
  end

  private
  def get_empresa
    @empresa = Empresa.find_by(id: params[:empresa_id])
    redirect_to root_path, notice: "Acción invalida." if !@empresa
  end 

  def correct_user
    redirect_to empresa_users_path(current_user.empresa_id), notice: "No tienes permiso para realizar esa acción." if !(current_user.is_admin == "1" and current_user.empresa == @empresa)
  end
   
  def area_params
    permited = [:name]
    @empresa.users.where(area_id: nil).each do |user|
      permited.push(user.id.to_s)
    end
    params.require(:area).permit(permited)
  end
end
