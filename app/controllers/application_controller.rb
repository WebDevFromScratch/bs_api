class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate_access
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def authenticate_access
    authenticate_with_token || render_unauthorized
  end

  def authenticate_with_token
    authenticate_with_http_token do |token, _options|
      token == Rails.application.secrets.api_access_token
    end
  end

  def record_not_found
    render json: { errors: 'Not found' }, status: :not_found
  end

  def render_unauthorized
    render json: { errors: 'Unauthorized' }, status: :unauthorized
  end
end
