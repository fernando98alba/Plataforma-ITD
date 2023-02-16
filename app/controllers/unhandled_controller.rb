class UnhandledController < ApplicationController

  def show
    redirect_to root_path, notice: "Acción invalida."
  end
end