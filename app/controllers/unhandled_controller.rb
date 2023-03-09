class UnhandledController < ApplicationController

  def show
    redirect_to root_path, notice: "Acción inválida."
  end
end