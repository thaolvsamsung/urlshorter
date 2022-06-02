class Api::V1::BaseController < ApplicationController
  respond_to :json
  protect_from_forgery with: :null_session

  private
  def authenticate_user!(options = {})
    if request.headers['Authorization'].present?
      authenticate_with_http_token do |token, options|
        begin
          jwt_payload = JWT.decode(token, Rails.application.secrets.secret_key_base).first
          @current_user_id = jwt_payload['id']
        rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
          @current_user_id = nil
        end
      end
    end
    render(json: { error: 'Not Authorized' }, status: :unauthorized) unless signed_in?
  end

  def current_user
    @current_user ||= super || User.find(@current_user_id)
  end

  def signed_in?
    @current_user_id.present?
  end
end
