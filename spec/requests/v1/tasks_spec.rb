# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Project', type: :request do
  let(:user) { FactoryBot.create(:user) }
  before {
    post '/api/v1/auth/sign_in',
    params: {
      email: user.email,
      password: user.password
    }
  }
  let(:token) { json_response[:token] }
  let(:project) { FactoryBot.create(:project, user: user) }

  describe 'GET /api/v1/project/:project_id/tasks' do
    let!(:projects) { FactoryBot.create_list(:task, 3, project: project) }
    before { get "/api/v1/projects/#{project.id}/tasks", headers: { authorization: token } }

    it { expect(response).to have_http_status 200 }
  end

  describe 'GET /api/v1/project/:project_id/tasks/:id' do
    let!(:task) { FactoryBot.create(:task, project: project) }
    before { get "/api/v1/projects/#{project.id}/tasks/#{task.id}", headers: { authorization: token } }

    it { expect(response).to have_http_status 200 }
  end

  describe 'POST /api/v1/project/:project_id/tasks' do
    context 'when correct data provided' do
      before {
        post "/api/v1/projects/#{project.id}/tasks",
        headers: { authorization: token },
        params: { name: Faker::Commerce.product_name }
      }
      it { expect(response).to have_http_status 201 }
    end

    context 'when incorrect data provided' do
      before {
        post "/api/v1/projects/#{project.id}/tasks",
        headers: { authorization: token }
      }
      it { expect(response).to have_http_status 422 }
    end

    context 'when authorization token missed' do
      before { post "/api/v1/projects/#{project.id}/tasks" }
      it { expect(response).to have_http_status 401 }
    end
  end

  describe 'PUT /api/v1/project/:project_id/tasks/:id' do
    let(:task) { FactoryBot.create(:task, project: project) }
    let(:attrs) { FactoryBot.attributes_for(:task) }
    before {
      put "/api/v1/projects/#{project.id}/tasks/#{task.id}",
      headers: { authorization: token },
      params: {
        name: attrs[:name],
        deadline: attrs[:deadline],
        done: attrs[:done],
        change_priority: %w[up down][rand(0..1)]
      }
    }

    it { expect(response).to have_http_status 200 }
  end

  describe 'DELETE /api/v1/project/:project_id/tasks/:id' do
    let(:task) { FactoryBot.create(:task, project: project) }
    before {
      delete "/api/v1/projects/#{project.id}/tasks/#{task.id}",
      headers: { authorization: token }
    }

    it { expect(response).to have_http_status 204 }
  end
end
