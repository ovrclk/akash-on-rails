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
    @pin = Pin.find(params[:id])
    if @pin.user == current_user || current_user.admin?
      @pin.destroy
      redirect_to root_path, flash: { notice: 'Pin deleted' }
    else
      redirect_to root_path, flash: { alert: 'You cannot delete that pin' }
    end
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
