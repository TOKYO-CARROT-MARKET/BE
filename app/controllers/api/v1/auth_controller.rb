class Api::V1::AuthController < ApplicationController
  before_action :require_authentication, only: [ :me, :logout ]

  def signup
    user = User.new(signup_params)

    if user.save
      session[:user_id] = user.id

      render json: user_response(user), status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email].to_s.strip.downcase)

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      render json: user_response(user)
    else
      render json: { error: "이메일 또는 비밀번호가 올바르지 않습니다." }, status: :unauthorized
    end
  end

  def me
    render json: user_response(current_user)
  end

  def logout
    reset_session
    head :no_content
  end

  private

  def signup_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def user_response(user)
    {
      id: user.id,
      email: user.email,
      created_at: user.created_at,
      updated_at: user.updated_at
    }
  end
end
