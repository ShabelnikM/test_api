# frozen_string_literal: true
class V1::UsersController < V1::ApplicationController
  before_action :authorize_request, only: %i[show]
  before_action :set_user, only: %i[show]

  api :GET, 'v1/users/:id', 'Show user. Authorization token required.'
  example <<-DATA
  RESPONSE
  {
    "data": {
      "id": "7169af40-6fee-4c48-9227-d3d08233fa19",
      "type": "user",
      "attributes": {
        "username": "test",
        "email": "test@example.com"
      },
      "links": {
        "self": "/api/v1/users/7169af40-6fee-4c48-9227-d3d08233fa19"
      }
    },
    "jsonapi": {
      "version": "1.0"
    }
  }
  DATA
  def show
    render jsonapi: @user, class: ->(_) { V1::SerializableUser }, status: :ok
  end

  api :POST, 'v1/auth/sign_up', 'Sign up new User.'
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
    "data": {
      "id": "7169af40-6fee-4c48-9227-d3d08233fa19",
      "type": "user",
      "attributes": {
        "username": "test",
        "email": "test@example.com"
      },
      "links": {
        "self": "/api/v1/users/7169af40-6fee-4c48-9227-d3d08233fa19"
      }
    },
    "jsonapi": {
      "version": "1.0"
    }
  }
  DATA
  example <<-DATA
  422 ERROR RESPONSE
  {
    "errors": [
      {
        "title": "Invalid email",
        "detail": "Email can't be blank",
        "source": {}
      },
      {
        "title": "Invalid email",
        "detail": "Email is invalid",
        "source": {}
      },
      {
        "title": "Invalid username",
        "detail": "Username can't be blank",
        "source": {}
      },
      {
        "title": "Invalid username",
        "detail": "Username is too short (minimum is 3 characters)",
        "source": {}
      },
      {
        "title": "Invalid password",
        "detail": "Password is too short (minimum is 8 characters)",
        "source": {}
      }
    ],
    "jsonapi": {
      "version": "1.0"
    }
  }
  DATA
  def create
    user = V1::UserForm.new(user_params)
    if user.save
      render jsonapi: user.object, class: ->(_) { V1::SerializableUser }, status: :created
    else
      render jsonapi_errors: user.errors, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.permit(%i[username email password password_confirmation])
  end
end
