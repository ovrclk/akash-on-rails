class PinsController < ApplicationController
  def index
    @pins = Pin.all
    @pin = Pin.new
  end

  def create
    Pin.create(pin_params)
    redirect_to root_path
  end

  def destroy
    Pin.find(params[:id]).destroy
    redirect_to root_path
  end

  private

  def pin_params
    params.require(:pin).permit(:title, :description, :link, :image)
  end
end
