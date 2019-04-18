# frozen_string_literal: true
class V1::AuthenticationController < V1::ApplicationController
  before_action :authorize_request, only: %i[update destroy]

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
      generate_token(user)
    else
      error_responce('Invalid login credentials')
    end
  end

  api :PUT, 'v1/auth/refresh', 'Refresh authorization token.'
  error code: 401, desc: 'Authorization token does not provided'
  description 'Refresh authorization token using the old one provided via header. Used token became invalid.'
  example <<-DATA
  RESPONSE:
  {
    "token": "new auth token",
    "exp": "token`s expiration date",
    "user_id": "user id"
  }
  DATA
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
  def update
    blacklisted_token
    generate_token(@current_user)
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
    blacklisted_token
    head :no_content, status: :ok
  end

  private

  def blacklisted_token
    Rails.cache.write("tokens_blacklist/#{@header}", true, expires_in: 24.hours)
  end

  def generate_token(user)
    token = JsonWebToken.encode(user_id: user.id)
    exp = (Time.now + 24.hours).strftime('%m-%d-%Y %H:%M')
    render json: { token: token, exp: exp, user_id: user.id }, status: :ok
  end

  def login_params
    params.permit(%i[email password])
  end
end
