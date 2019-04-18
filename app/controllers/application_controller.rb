# frozen_string_literal: true
class ApplicationController < ActionController::API
  include Pundit
  attr_reader :current_user

  rescue_from Pundit::NotAuthorizedError, with: :error_responce

  private

  def authorize_request
    header = request.headers['authorization']
    @header = header.split(' ').last if header
    begin
      raise ActiveRecord::RecordNotFound if Rails.cache.read("tokens_blacklist/#{@header}")

      decoded = JsonWebToken.decode(@header)
      @current_user = User.find(decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      error_responce
    rescue JWT::DecodeError
      error_responce
    end
  end

  def error_responce(error = 'Invalid authorization token')
    render json: {
      errors: [
        {
          title: error,
          detail: error,
          source: {}
        }
      ],
      jsonapi: { version: '1.0' }
    }, status: :unauthorized
  end
end
