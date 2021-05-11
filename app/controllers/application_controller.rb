class ApplicationController < ActionController::Base
  private

  def current_user
    session[:userinfo]
  end
  helper_method :current_user
end
