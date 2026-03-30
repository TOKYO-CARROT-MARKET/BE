class ApplicationController < ActionController::API
  include ActionController::Cookies

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def require_authentication
    return if current_user.present?

    render json: { error: "Unauthorized" }, status: :unauthorized
  end

  def render_not_found
    render json: { error: "Not found" }, status: :not_found
  end
end
