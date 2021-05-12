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

  def require_admin
    return if current_user&.admin?

    redirect_to root_path, flash: { alert: 'Admin user required' }
  end
end
