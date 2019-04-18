# frozen_string_literal: true
class V1::CommentsController < V1::ApplicationController
  before_action :authorize_request
  before_action :set_comment, only: %i[destroy]

  api :GET, 'v1/tasks/:task_id/comments', 'Show task comments. Authorization token required.'
  error code: 401, desc: 'Invalid authorization token provided.'
  example <<-DATA
  RESPONSE
  {
    "data": [
      {
        "id": "0b554605-c19f-41b8-9252-db188dcbe0a7",
        "type": "comment",
        "attributes": {
          "text": "test comment",
          "image": "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--91246088ddbb3b2098b781b166e51bf180e82e54/photo_2018-05-31_09-52-01.jpg"
        },
        "relationships": {
          "task": {
            "links": {
              "related": "/api/v1/projects/003b9e56-a041-4819-9c3d-dda57e37f0a2/tasks/2371bde2-a95f-4e17-b866-eaa7ae8bcb20"
            }
          }
        }
      },
      {
        "id": "6a9e0530-b3be-4383-8580-fd7df4ec105d",
        "type": "comment",
        "attributes": {
          "text": "test comment",
          "image": "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--1e16503b638eb1865f6540524817a382e9f4ad23/photo_2018-05-31_09-52-01.jpg"
        },
        "relationships": {
          "task": {
            "links": {
              "related": "/api/v1/projects/003b9e56-a041-4819-9c3d-dda57e37f0a2/tasks/2371bde2-a95f-4e17-b866-eaa7ae8bcb20"
            }
          }
        }
      },
      {
        "id": "61377446-dcef-4c86-b3a9-118cc60309ad",
        "type": "comment",
        "attributes": {
          "text": "test comment",
          "image": "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--8dbb44e12df03f6fe06ca475f235e6bb520b6f54/photo_2018-05-31_09-52-01.jpg"
        },
        "relationships": {
          "task": {
            "links": {
              "related": "/api/v1/projects/003b9e56-a041-4819-9c3d-dda57e37f0a2/tasks/2371bde2-a95f-4e17-b866-eaa7ae8bcb20"
            }
          }
        }
      },
      {
        "id": "a7d10c91-3fc2-49dd-b4ad-2341f45ea4f1",
        "type": "comment",
        "attributes": {
          "text": "test comment",
          "image": "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--91246088ddbb3b2098b781b166e51bf180e82e54/photo_2018-05-31_09-52-01.jpg"
        },
        "relationships": {
          "task": {
            "links": {
              "related": "/api/v1/projects/003b9e56-a041-4819-9c3d-dda57e37f0a2/tasks/2371bde2-a95f-4e17-b866-eaa7ae8bcb20"
            }
          }
        }
      }
    ],
    "jsonapi": {
      "version": "1.0"
    }
  }
  DATA
  example <<-DATA
  401 ERROR RESPONSE:
  {
    "errors": [
      {
        "title": "Invalid authorization token",
        "detail": "Invalid authorization token",
        "source": {}
      }
    ],
    "jsonapi": {
      "version": "1.0"
    }
  }
  DATA
  def index
    render jsonapi: Task.find(params[:task_id]).comments, class: ->(_) { V1::SerializableComment }, status: :ok
  end

  api :POST, 'v1/tasks/:task_id/comments', 'Create new comment. Use multipart form instead of simple JSON request in order to upload image. Authorization token required.'
  error code: 401, desc: 'Invalid authorization token provided.'
  error code: 422, desc: 'Invalid params.'
  formats ['multipart/form-data']
  param :text, String, desc: 'Comment text'
  param :image, String, desc: 'Image in jpg, jpeg or png extension. Must be less then 10mb.'
  example <<-DATA
  RESPONSE
  {
    "data": {
      "id": "800d0949-50bd-4c6a-ae02-72d281347207",
      "type": "comment",
      "attributes": {
        "text": "test comment",
        "image": "/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBEUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--b72f61a7a0496cf5a5bcd9ffac22f3ab6ea283ed/photo_2018-05-31_09-52-01.jpg"
      },
      "relationships": {
        "task": {
          "links": {
            "related": "/api/v1/projects/003b9e56-a041-4819-9c3d-dda57e37f0a2/tasks/2371bde2-a95f-4e17-b866-eaa7ae8bcb20"
          }
        }
      }
    },
    "jsonapi": {
      "version": "1.0"
    }
  }
  DATA
  example <<-DATA
  401 ERROR RESPONSE
  {
    "errors": [
      {
        "title": "Invalid authorization token",
        "detail": "Invalid authorization token",
        "source": {}
      }
    ],
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
        "title": "Invalid text",
        "detail": "Text is too short (minimum is 10 characters)",
        "source": {}
      },
      {
        "title": "Invalid image",
        "detail": "Image file should be one of image/jpg, image/jpeg, image/png",
        "source": {}
      }
    ],
    "jsonapi": {
      "version": "1.0"
    }
  }
  DATA
  def create
    comment = V1::CommentForm.new(comment_params)
    if comment.save
      render jsonapi: comment.object, class: ->(_) { V1::SerializableComment }, status: :created
    else
      render jsonapi_errors: comment.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, 'v1/tasks/:task_id/comments/:id', 'Delete comment. Authorization token required.'
  error code: 401, desc: 'Invalid authorization token provided.'
  example <<-DATA
  401 ERROR RESPONSE:
  {
    "errors": [
      {
        "title": "Invalid authorization token",
        "detail": "Invalid authorization token",
        "source": {}
      }
    ],
    "jsonapi": {
      "version": "1.0"
    }
  }
  DATA
  def destroy
    if @comment.destroy
      head :no_content, status: :ok
    else
      render jsonapi_errors: @comment.errors, status: :unprocessable_entity
    end
  end

  private

  def set_comment
    @comment = authorize Comment.find(params[:id])
  end

  def comment_params
    # default params fixes 500 error caused by empty body of multipart request
    defaults = { text: nil, task_id: params[:task_id], image: nil }
    params.permit(%i[text task_id image]).reverse_merge(defaults)
  end
end
