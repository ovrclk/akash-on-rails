class ApplicationController < ActionController::Base
  private

  def current_user
    return unless session[:user_id].present?

    @current_user ||= User.find_by(id: session[:user_id])
  end
  helper_method :current_user

  def require_user
    return if current_user

    redirect_to root_path, flash: { alert: 'Please login first' }
  end
end
