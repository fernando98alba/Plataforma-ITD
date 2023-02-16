class UsersController < ApplicationController
  before_action :get_empresa, only: [:index]
  before_action :get_user, only: [:show]
  before_action :authenticate_user!
  before_action :correct_user, only: [:show]#cualquier miembro del equipo?
  before_action :correct_user_empresa, only: [:index]
  
  def create
  end

  def show #SHOW INVITATIONS PENDING
    @user = User.find(params[:id])
  end

  def index
    @users = @empresa.users.order(id: :asc).all
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_index_path
  end

  def invite_member #ALERT IF INVITED_USER = CURRENT_USER #AGREGAR CASOS EN QUE ESTE INVITADO Y NO HAYA ACEPTADO
    user = User.find_by(email: invitation_param[:email])
    if user
      if user != current_user
        if user.empresa_id == nil or (user.empresa_id == current_user.empresa_id and !user.accepted_or_not_invited?) #ALERTA SI EXISTE
          user.empresa = current_user.empresa
          user.save
          user.invite!(current_user)
          flash[:alert] = "Invitación enviada con exito"
        elsif user.empresa_id != current_user.empresa_id
          #ADD ALERT
          flash[:alert] = "Usuario ya pertenece a otra organización"
        else
          #ADD ALERT
          flash[:alert] = "Usuario ya fue agregado a la organización"
        end
      else
        flash[:alert] = "No puedes agregarte a ti mismo"
      end
    else
      User.invite!({email: invitation_param[:email], empresa: current_user.empresa}, current_user)
      flash[:alert] = "Usuario invitado con exito"
    end
    redirect_to empresa_users_path(current_user.empresa_id)
  end

  private

  def correct_user
    redirect_to root_path, notice: "No tienes permiso realizar esa acción." if !(@user == current_user or (@empresa == current_user.empresa and current_user.is_admin))
  end

  def correct_user_empresa
    redirect_to root_path, notice: "No tienes permiso realizar esa acción." if current_user.empresa != @empresa
  end

  def get_empresa
    @empresa = Empresa.find_by(id: params[:empresa_id])
    redirect_to root_path, notice: "Acción invalida." if !@empresa
  end 

  def get_user
    @user = User.find_by(id: params[:id])
    redirect_to root_path, notice: "Acción invalida." if !@user
  end 

  def invitation_param
    params.require(:user).permit(:email)
  end
end
