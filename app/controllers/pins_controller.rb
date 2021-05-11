class PinsController < ApplicationController
  before_action :require_user, only: %i[create update destroy]

  def index
    @pins = find_pins
    @pin = Pin.new
  end

  def create
    current_user.pins.create(pin_params)
    redirect_to root_path
  end

  def destroy
    current_user.pins.find(params[:id]).destroy
    redirect_to root_path
  end

  private

  def find_pins
    if params[:user_id]
      Pin.where(user_id: params[:user_id])
    else
      Pin.all
    end
  end

  def pin_params
    params.require(:pin).permit(:title, :description, :link, :image)
  end
end
