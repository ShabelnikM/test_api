# frozen_string_literal: true
class V1::AuthenticationController < V1::ApplicationController
  before_action :authorize_request, only: %i[destroy]

  api :POST, 'v1/auth/sign_in', 'Sign in user.'
  error code: 401, desc: 'Empty email or password'
  description 'sign in, return auth token. Add it to any request header as [authorization]'
  param :email, String, desc: 'email'
  param :password, String, desc: 'password'
  example <<-DATA
  REQUEST:
  {
    "email":"test@example.com",
    "password":"147896325"
  }
  DATA
  example <<-DATA
  RESPONSE:
  {
    "token": "auth token",
    "exp": "token`s expiration date",
    "user_id": "user id"
  }
  DATA
  example <<-DATA
  401 ERROR RESPONSE:
  {
    "errors": [
      {
        "title": "Invalid login credentials",
        "detail": "Invalid login credentials. Please try again",
        "source": {}
      }
    ],
    "jsonapi": {
      "version": "1.0"
    }
  }
  DATA
  def create
    user = User.find_by_email(params[:email])
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      exp = (Time.now + 24.hours).strftime('%m-%d-%Y %H:%M')
      render json: { token: token, exp: exp, user_id: user.id }, status: :ok
    else
      error_responce('Invalid login credentials')
    end
  end

  api :DELETE, 'v1/auth/sign_out', 'Sign out user. Authorization token required.'
  error code: 401, desc: 'Authorization token does not provided'
  description 'sign out, using current auth token.'
  example <<-DATA
  401 ERROR RESPONSE:
  {
    "errors": [
      {
        "title": "Invalid authorization token",
        "detail": "Invalid authorization token",
        "source": {}
      }
    ],
    "jsonapi": {
      "version": "1.0"
    }
  }
  DATA
  def destroy
    Rails.cache.write("tokens_blacklist/#{@header}", true, expires_in: 24.hours)
    head :no_content, status: :ok
  end

  private

  def login_params
    params.permit(%i[email password])
  end
end
