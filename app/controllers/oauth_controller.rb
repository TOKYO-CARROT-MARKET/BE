class OauthController < ApplicationController
  def google
    redirect_path = params[:redirect_path].presence || "/"
    session[:oauth_redirect_path] = sanitize_redirect_path(redirect_path)
    redirect_to "/auth/google_oauth2"
  end

  def google_callback
    auth = request.env["omniauth.auth"]

    user = User.find_or_create_from_google!(auth: auth.to_h.deep_symbolize_keys)
    session[:user_id] = user.id

    redirect_to "#{frontend_url}#{session.delete(:oauth_redirect_path) || '/'}", allow_other_host: true
  end

  def failure
    redirect_to "#{frontend_url}/login?error=oauth_failed", allow_other_host: true
  end

  private

  def frontend_url
    ENV.fetch("FRONTEND_URL")
  end

  def sanitize_redirect_path(path)
    return "/" unless path.start_with?("/")
    return "/" if path.start_with?("//")

    path
  end
end