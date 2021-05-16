class PinsController < ApplicationController
  before_action :require_user, except: :index

  def index
    @pins = find_pins
  end

  def new
    @pin = Pin.new
  end

  def create
    @pin = current_user.pins.create(pin_params)
    @pins = find_pins
  end

  def edit
    @pin = Pin.find(params[:id])
    render 'new'
  end

  def update
    @pin = Pin.find(params[:id])
    if @pin.user == current_user || current_user.admin?
      @pin.update(pin_params)
      @pins = find_pins
      render 'create'
    else
      raise ActionNotFound
    end
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
    pins = Pin.order(created_at: :desc)
    return pins unless params[:user_id].present?

    pins.where(user_id: params[:user_id])
  end

  def pin_params
    params.require(:pin).permit(:title, :description, :link, :image)
  end
end
