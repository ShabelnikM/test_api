class ApplicationController < ActionController::API
  include Pundit
  attr_reader :current_user

  rescue_from Pundit::NotAuthorizedError, with: :request_not_authorized

  private

  def authorize_request
    header = request.headers['authorization']
    @header = header.split(' ').last if header
    begin
      raise ActiveRecord::RecordNotFound if Rails.cache.read("tokens_blacklist/#{@header}")

      decoded = JsonWebToken.decode(@header)
      @current_user = User.find(decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      request_not_authorized
    rescue JWT::DecodeError
      request_not_authorized
    end
  end

  def request_not_authorized
    render json: {
      errors: [
        {
          title: 'Invalid authorization token',
          detail: 'Invalid authorization token',
          source: {}
        }
      ],
      jsonapi: { version: '1.0' }
    }, status: :unauthorized
  end
end
