# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'V1::Comment', type: :request do
  let(:user) { FactoryBot.create(:user) }
  before {
    post v1_auth_sign_in_url,
    params: {
      email: user.email,
      password: user.password
    }
  }
  let(:token) { json_response[:token] }
  let(:project) { FactoryBot.create(:project, user: user) }
  let(:task) { FactoryBot.create(:task, project: project) }

  describe 'GET /api/v1/tasks/:task_id/comments' do
    let!(:comments) { FactoryBot.create_list(:comment, 3, task: task) }
    before { get v1_task_comments_url(task.id), headers: { authorization: token } }

    it { expect(response).to have_http_status 200 }
    it { expect(json_response[:data].count).to eq(3) }
  end

  describe 'POST /api/v1/tasks/:task_id/comments' do
    context 'when correct data provided' do
      before {
        post v1_task_comments_url(task.id),
        headers: { authorization: token },
        params: {
          text: Faker::Lorem.sentence,
          image: Rack::Test::UploadedFile.new('./public/test.jpg', 'image/jpg')
        }
      }
      it { expect(response).to have_http_status 201 }
    end

    context 'when incorrect data provided' do
      before {
        post v1_task_comments_url(task.id),
        headers: { authorization: token }
      }
      it { expect(response).to have_http_status 422 }
    end

    context 'when authorization token missed' do
      before { post v1_task_comments_url(task.id) }
      it { expect(response).to have_http_status 401 }
    end
  end

  describe 'DELETE /api/v1/tasks/:task_id/comments/:id' do
    let(:comment) { FactoryBot.create(:comment, task: task) }
    before { delete v1_task_comment_url(task.id, comment.id), headers: { authorization: token } }

    it { expect(response).to have_http_status 204 }
  end
end
