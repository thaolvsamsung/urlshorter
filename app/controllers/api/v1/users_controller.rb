class Api::V1::UsersController < Api::V1::BaseController
  before_action :current_user, except: :authenticate
  skip_before_action :authenticate_user!, only: :authenticate

  def authenticate
    user = User.find_by_email(login_params[:email])
    if user && user.valid_password?(login_params[:password])
      @current_user = user
    else
      render json: { errors: { 'email or password' => ['is invalid'] } }, status: :unprocessable_entity
    end
  end

  private
  def login_params
    params.permit(:email, :password)
  end
end
