class ApplicationController < ActionController::API
  before_action :authorize_request

  private

  def current_user
    @current_user
  end

  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header.present?

    decoded = JsonWebToken.decode(token)
    @current_user = User.find_by(id: decoded[:user_id]) if decoded
  rescue ActiveRecord::RecordNotFound, JWT::DecodeError
    render json: { errors: ['Unauthorized'] }, status: :unauthorized
  end
end
