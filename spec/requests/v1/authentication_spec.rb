# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Authentication', type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe 'POST /api/v1/auth/sign_in' do
    context 'when correct email and password provided' do
      before {
        post '/api/v1/auth/sign_in',
        params: {
          email: user.email,
          password: user.password
        }
      }
      it { expect(response).to have_http_status 200 }
    end

    context 'when incorrect email and password provided' do
      before {
        post '/api/v1/auth/sign_in',
        params: {
          email: Faker::Internet.email,
          password: SecureRandom.urlsafe_base64(8)
        }
      }
      it { expect(response).to have_http_status 401 }
    end

    context 'when no email and password provided' do
      before { post '/api/v1/auth/sign_in' }
      it { expect(response).to have_http_status 401 }
    end
  end

  describe 'DELETE /api/v1/auth/sign_out' do
    context 'when authorization token provided' do
      before {
        post '/api/v1/auth/sign_in',
        params: {
          email: user.email,
          password: user.password
        }
      }
      let(:token) { json_response[:token] }
      before { delete '/api/v1/auth/sign_out', headers: { authorization: token } }

      it { expect(response).to have_http_status 204 }
    end

    context 'when authorization token does not provided' do
      before { delete '/api/v1/auth/sign_out' }
      it { expect(response).to have_http_status 401 }
    end
  end
end
