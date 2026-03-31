class Api::V1::AuthController < ApplicationController
  before_action :require_authentication, only: %i[me logout]

  def me
    render json: user_response(current_user)
  end

  def logout
    reset_session
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