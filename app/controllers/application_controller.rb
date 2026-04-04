class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def current_user
    @current_user ||= begin
      payload = JwtService.decode_access(bearer_token)
      User.find_by(id: payload[:user_id]) if payload
    end
  end

  def require_authentication
    return if current_user.present?

    render json: { error: "Unauthorized" }, status: :unauthorized
  end

  def bearer_token
    header = request.headers["Authorization"]
    header&.start_with?("Bearer ") ? header.split(" ").last : nil
  end

  def render_not_found
    render json: { error: "Not found" }, status: :not_found
  end
end
