# frozen_string_literal: true
class V1::UsersController < V1::ApplicationController

  api :POST, 'v1/auth/sign_up', 'Sign up new User'
  error code: 422, desc: 'Invalid data for sign up.'
  param :username, String, desc: 'email'
  param :email, String, desc: 'email'
  param :password, String, desc: 'password'
  param :password_confirmation, String, desc: 'password confirmation'
  example <<-DATA
  REQUEST:
  {
    "username": "Test"
    "email":"test@example.com",
    "password":"147896325",
    "password_confirmation":"147896325"
  }
  DATA
  example <<-DATA
  RESPONSE
  {
    "success": "User Test created!"
  }
  DATA
  example <<-DATA
  ERROR_RESPONSE
  {
    "errors": [
      "Password can't be blank",
      "Password is too short (minimum is 8 characters)",
      "Password and password confirmation does not match",
      "Email can't be blank",
      "Email is invalid",
      "Username can't be blank",
      "Username is too short (minimum is 3 characters)"
    ]
  }
  DATA
  def create
    user = V1::UserForm.new(user_params)
    if user.save
      render json: { success: "User #{user.username} created!" }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(%i[username email password password_confirmation])
  end
end
