# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Project', type: :request do
  let(:user) { FactoryBot.create(:user) }
  before {
    post v1_auth_sign_in_url,
    params: {
      email: user.email,
      password: user.password
    }
  }
  let(:token) { json_response[:token] }

  describe 'GET /api/v1/users/:user_id/projects' do
    let!(:projects) { FactoryBot.create_list(:project, 3, user: user) }
    before { get v1_user_projects_url(user.id), headers: { authorization: token } }

    it { expect(response).to have_http_status 200 }
  end

  describe 'GET /api/v1/users/:user_id/projects/:id' do
    let!(:project) { FactoryBot.create(:project, user: user) }
    before { get v1_user_project_url(user.id, project.id), headers: { authorization: token } }

    it { expect(response).to have_http_status 200 }
  end

  describe 'POST /api/v1/users/:user_id/projects' do
    context 'when correct data provided' do
      before {
        post v1_user_projects_url(user.id),
        headers: { authorization: token },
        params: { name: Faker::Commerce.product_name }
      }
      it { expect(response).to have_http_status 201 }
    end

    context 'when incorrect data provided' do
      before {
        post v1_user_projects_url(user.id),
        headers: { authorization: token }
      }
      it { expect(response).to have_http_status 422 }
    end

    context 'when authorization token missed' do
      before { post v1_user_projects_url(user.id) }
      it { expect(response).to have_http_status 401 }
    end
  end

  describe 'PUT /api/v1/users/:user_id/projects/:id' do
    let!(:project) { FactoryBot.create(:project, user: user) }
    before {
      put v1_user_project_url(user.id, project.id),
      headers: { authorization: token },
      params: { name: Faker::Commerce.product_name }
    }

    it { expect(response).to have_http_status 200 }
  end

  describe 'DELETE /api/v1/users/:user_id/projects/:id' do
    let!(:project) { FactoryBot.create(:project, user: user) }
    before {
      delete v1_user_project_url(user.id, project.id),
      headers: { authorization: token }
    }

    it { expect(response).to have_http_status 204 }
  end
end
