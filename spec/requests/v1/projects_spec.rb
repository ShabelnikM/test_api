# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::User', type: :request do
  let(:user) { FactoryBot.create(:user) }
  before {
    post '/api/v1/auth/sign_in',
    params: {
      email: user.email,
      password: user.password
    }
  }
  let(:token) { json_response[:token] }

  describe 'POST /api/v1/users/:user_id/projects' do
    context 'when correct data provided' do
      before {
        post "/api/v1/users/#{user.id}/projects",
        headers: { authorization: token },
        params: { name: Faker::Commerce.product_name }
      }
      it { expect(response).to have_http_status 201 }
    end

    context 'when incorrect data provided' do
      before {
        post "/api/v1/users/#{user.id}/projects",
        headers: { authorization: token }
      }
      it { expect(response).to have_http_status 422 }
    end

    context 'when authorization token missed' do
      before { post "/api/v1/users/#{user.id}/projects" }
      it { expect(response).to have_http_status 401 }
    end
  end
end
