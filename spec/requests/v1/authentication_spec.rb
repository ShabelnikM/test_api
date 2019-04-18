# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Authentication', type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe 'POST /api/v1/auth/sign_in' do
    context 'when correct email and password provided' do
      before {
        post v1_auth_sign_in_url,
        params: {
          email: user.email,
          password: user.password
        }
      }
      it { expect(response).to have_http_status 200 }
      it { expect(json_response[:user_id]).to eq(user.id) }
      it { expect(json_response[:token]).not_to be_nil }
      it { expect(json_response[:exp]).not_to be_nil }
    end

    context 'when incorrect email and password provided' do
      before {
        post v1_auth_sign_in_url,
        params: {
          email: Faker::Internet.email,
          password: SecureRandom.urlsafe_base64(8)
        }
      }
      it { expect(response).to have_http_status 401 }
    end

    context 'when no email and password provided' do
      before { post v1_auth_sign_in_url }
      it { expect(response).to have_http_status 401 }
    end
  end

  describe 'PUT /api/v1/auth/refresh' do
    context 'when authorization token provided' do
      before {
        post v1_auth_sign_in_url,
        params: {
          email: user.email,
          password: user.password
        }
      }
      let(:token) { json_response[:token] }
      before { put v1_auth_refresh_url, headers: { authorization: token } }

      it { expect(response).to have_http_status 200 }
      it { expect(json_response[:user_id]).to eq(user.id) }
      it { expect(json_response[:token]).not_to be_nil }
      it { expect(json_response[:exp]).not_to be_nil }
    end

    context 'when authorization token provided old token added to blacklist' do
      before {
        post v1_auth_sign_in_url,
        params: {
          email: user.email,
          password: user.password
        }
      }
      let(:token) { json_response[:token] }
      before { put v1_auth_refresh_url, headers: { authorization: token } }
      before { put v1_auth_refresh_url, headers: { authorization: token } }

      it { expect(response).to have_http_status 401 }
    end

    context 'when authorization token does not provided' do
      before { put v1_auth_refresh_url }

      it { expect(response).to have_http_status 401 }
    end
  end

  describe 'DELETE /api/v1/auth/sign_out' do
    context 'when authorization token provided' do
      before {
        post v1_auth_sign_in_url,
        params: {
          email: user.email,
          password: user.password
        }
      }
      let(:token) { json_response[:token] }
      before { delete v1_auth_sign_out_url, headers: { authorization: token } }

      it { expect(response).to have_http_status 204 }
    end

    context 'when authorization token does not provided' do
      before { delete v1_auth_sign_out_url }
      it { expect(response).to have_http_status 401 }
    end
  end
end
