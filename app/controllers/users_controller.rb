class UsersController < ApplicationController
  before_action :require_admin

  def index
    @users = User.order(id: :desc)
  end

  def update
    @user = User.find(params[:id])
    @user.update(permitted_params)
    redirect_to users_path, flash: { notice: 'User updated' }
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, flash: { notice: 'User deleted' }
  end

  private

  def permitted_params
    params.require(:user).permit(:admin)
  end
end
