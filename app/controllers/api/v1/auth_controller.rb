class Api::V1::AuthController < ApplicationController
  def login
    user = User.find_by(username: login_params[:username])

    if user&.authenticate(login_params[:password])
      render json: { message: "Login successful", user: user }, status: :ok
    else
      render json: { errors: [ "Invalid username or password" ] }, status: :unauthorized
    end
  end

  def register
    user = User.new(register_params)

    if user.save
      render json: { message: "User created successfully", user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login_params
    params.require(:user).permit(:username, :password)
  end

  def register_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
