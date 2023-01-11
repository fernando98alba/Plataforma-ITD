class HomesController < ApplicationController

  def index
    if user_signed_in?
      if current_user.empresa_id
        redirect_to empresa_path(current_user.empresa_id)
      else
        render
      end
    else
      render
    end
  end
  
end
