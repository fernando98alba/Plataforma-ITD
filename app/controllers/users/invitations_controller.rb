# frozen_string_literal: true

class Users::InvitationsController < DeviseController
  before_action :check_session
  prepend_before_action :resource_from_invitation_token, only: [:edit, :destroy] #ADD LOG OUT IF LOGED IN
  # GET /resource/invitation/new
  def new
    super
  end

  # POST /resource/invitation
  def create
    super
  end

  # GET /resource/accept?invitation_token=abcdef
  def edit
    if resource.created_by_invite? and resource.invitation_accepted?
      set_minimum_password_length
      resource.invitation_token = params[:invitation_token]
      render :edit
    else
      puts resource.empresa_id
      resource.accept_invitation()
      resource.save
      redirect_to new_user_session_path
    end
  end

  # PUT /resource/invitation
  def update
    puts update_resource_params
    raw_invitation_token = update_resource_params[:invitation_token]
    resource = accept_resource
    invitation_accepted = resource.errors.empty?
    puts raw_invitation_token
    if invitation_accepted
      sign_in(resource)
      redirect_to root_path
    else
      resource.invitation_token = raw_invitation_token
      redirect_to "/resource/accept?invitation_token=#{raw_invitation_token}"
    end
  end

  # GET /resource/invitation/remove?invitation_token=abcdef
  def destroy
    resource.destroy
    set_flash_message :notice, :invitation_removed if is_flashing_format?
    redirect_to root_path
  end

  protected
    def check_session
      if current_user
        sign_out(current_user)
      end
    end
    # This is called when creating invitation.
    # It should return an instance of resource class.
    def invite_resource (&block)
      # skip sending emails on invite
      resource_class.invite!(invite_params, current_inviter, &block)
    end

    # This is called when accepting invitation.
    # It should return an instance of resource class.
    def accept_resource
      resource = resource_class.accept_invitation!(update_resource_params)
      # Report accepting invitation to analytics
      resource
    end

    def resource_from_invitation_token
      unless params[:invitation_token] && self.resource = resource_class.find_by_invitation_token(params[:invitation_token], true)
        set_flash_message(:alert, :invitation_token_invalid) if is_flashing_format?
        redirect_to invalid_token_path_for(resource_name)
      end
    end

    def update_resource_params
      puts params
      devise_parameter_sanitizer.sanitize(:accept_invitation)
    end
end
