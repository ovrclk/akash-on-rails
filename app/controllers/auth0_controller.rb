class Auth0Controller < ApplicationController
  def callback
    auth_info = request.env['omniauth.auth']
    @current_user = User.find_or_create_by(uid: auth_info[:uid]) do |user|
      user.nickname = auth_info[:extra][:raw_info][:nickname]
    end
    session[:user_id] = @current_user.id

    redirect_to root_path
  end

  def failure
    @error_msg = request.params['message']
  end

  def logout
    reset_session
    redirect_to logout_url
  end

  private

  def logout_url
    request_params = {
      returnTo: root_url,
      client_id: ENV['AUTH0_ID']
    }

    URI::HTTPS.build(host: ENV['AUTH0_DOMAIN'], path: '/v2/logout', query: to_query(request_params)).to_s
  end

  def to_query(hash)
    hash.map { |k, v| "#{k}=#{CGI.escape(v)}" unless v.nil? }.reject(&:nil?).join('&')
  end
end
