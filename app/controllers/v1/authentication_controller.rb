# frozen_string_literal: true
class V1::AuthenticationController < V1::ApplicationController
  before_action :authorize_request, only: %i[destroy]

  api :POST, 'v1/auth/sign_in', 'Sign in'
  error code: 401, desc: 'Empty email or password'
  description 'sign in, return auth token. Add it to any request header as [Authorization]'
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
    "token": "example token",
    "exp": "expiration date",
    "username": "Username"
  }
  DATA
  example <<-DATA
  ERRORS_RESPONSE:
  {
    "errors": ["Invalid login credentials. Please try again."]
  }
  DATA
  def create
    user = User.find_by_email(params[:email])
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      time = Time.now + 24.hours.to_i
      render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"), username: user.username }, status: :ok
    else
      render json: { errors: ['Invalid login credentials. Please try again.'] }, status: :unauthorized
    end
  end

  #TODO: add token to redis blacklist
  def destroy
    render json: { success: 'Signed out successfully'}, status: :ok
  end

  private

  def login_params
    params.permit(%i[email password])
  end
end
