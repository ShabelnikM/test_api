# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::User', type: :request do
  let(:user) { FactoryBot.build_stubbed(:user) }

  describe 'POST /api/v1/auth/sign_up' do
    context 'when correct data provided' do
      before {
        post v1_auth_sign_up_url,
        params: {
          email: user.email,
          username: user.username,
          password: user.password,
          password_confirmation: user.password_confirmation
        }
      }

      it { expect(response).to have_http_status 201 }
      it { expect(json_response.dig(:data, :type)).to eq('user') }
      it { expect(json_response.dig(:data, :attributes, :username)).to eq(user.username) }
      it { expect(json_response.dig(:data, :attributes, :email)).to eq(user.email) }
    end

    context 'when incorrect data provided' do
      before { post v1_auth_sign_up_url }

      it { expect(response).to have_http_status 422 }
      it { expect(json_response[:errors]).not_to be_empty }
    end
  end
end
