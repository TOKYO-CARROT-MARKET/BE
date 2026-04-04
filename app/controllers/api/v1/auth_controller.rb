class Api::V1::AuthController < ApplicationController
  before_action :require_authentication, only: %i[me logout]

  def me
    render json: user_response(current_user)
  end

  def refresh
    payload = JwtService.decode_refresh(params[:refresh_token])

    if payload.nil?
      render json: { error: "Invalid refresh token" }, status: :unauthorized
      return
    end

    user = User.find_by(id: payload[:user_id])

    if user.nil?
      render json: { error: "User not found" }, status: :unauthorized
      return
    end

    render json: { access_token: JwtService.encode_access({ user_id: user.id }) }
  end

  def logout
    head :no_content
  end

  private

  def user_response(user)
    {
      id: user.id,
      email: user.email,
      nickname: user.nickname,
      profile_image_url: user.profile_image_url,
      created_at: user.created_at,
      updated_at: user.updated_at
    }
  end
end
