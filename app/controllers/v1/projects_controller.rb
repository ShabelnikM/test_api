# frozen_string_literal: true
class V1::ProjectsController < V1::ApplicationController
  before_action :authorize_request
  before_action :set_project, only: %i[show update destroy]

  api :GET, 'v1/users/:user_id/projects', 'Show user projects. Authorization token required.'
  example <<-DATA
  RESPONSE
  {
    "data": [
      {
        "id": "40ec133e-a30a-469a-90cc-cb38f2f93b10",
        "type": "project",
        "attributes": {
          "name": "Test project"
        },
        "relationships": {
          "user": {
            "links": {
              "related": "/api/v1/users/f09d9fed-dea1-4efb-811a-dd8692b8f5ca"
            }
          }
        },
        "links": {
          "self": "/api/v1/users/f09d9fed-dea1-4efb-811a-dd8692b8f5ca/projects/40ec133e-a30a-469a-90cc-cb38f2f93b10"
        }
      },
      {
        "id": "e2737587-3323-4273-b1e8-8ea1d981f8de",
        "type": "project",
        "attributes": {
          "name": "Test project"
        },
        "relationships": {
          "user": {
            "links": {
              "related": "/api/v1/users/f09d9fed-dea1-4efb-811a-dd8692b8f5ca"
            }
          }
        },
        "links": {
          "self": "/api/v1/users/f09d9fed-dea1-4efb-811a-dd8692b8f5ca/projects/e2737587-3323-4273-b1e8-8ea1d981f8de"
        }
      }
    ],
    "jsonapi": {
      "version": "1.0"
    }
  }
  DATA
  def index
    render jsonapi: @current_user.projects, class: ->(_) { V1::SerializableProject }, status: :ok
  end

  api :GET, 'v1/users/:user_id/projects/:id', 'Show project. Authorization token required.'
  example <<-DATA
  RESPONSE
  {
    "data": {
      "id": "dab457d2-512c-41a5-8261-99c5d2967f31",
      "type": "project",
      "attributes": {
        "name": "Test project"
      },
      "relationships": {
        "user": {
          "links": {
            "related": "/api/v1/users/f09d9fed-dea1-4efb-811a-dd8692b8f5ca"
          }
        }
      },
      "links": {
        "self": "/api/v1/users/f09d9fed-dea1-4efb-811a-dd8692b8f5ca/projects/dab457d2-512c-41a5-8261-99c5d2967f31"
      }
    },
    "jsonapi": {
      "version": "1.0"
    }
  }
  DATA
  def show
    render jsonapi: @project, class: ->(_) { V1::SerializableProject }, status: :ok
  end

  api :POST, 'v1/users/:user_id/projects', 'Create new project. Authorization token required.'
  error code: 401, desc: 'Invalid authorization token provided.'
  error code: 422, desc: 'Invalid params.'
  param :name, String, desc: 'name'
  example <<-DATA
  REQUEST:
  {
    "name": "Test project"
  }
  DATA
  example <<-DATA
  RESPONSE
  {
    "data": {
      "id": "dab457d2-512c-41a5-8261-99c5d2967f31",
      "type": "project",
      "attributes": {
        "name": "Test project"
      },
      "relationships": {
        "user": {
          "links": {
            "related": "/api/v1/users/f09d9fed-dea1-4efb-811a-dd8692b8f5ca"
          }
        }
      },
      "links": {
        "self": "/api/v1/users/f09d9fed-dea1-4efb-811a-dd8692b8f5ca/projects/dab457d2-512c-41a5-8261-99c5d2967f31"
      }
    },
    "jsonapi": {
      "version": "1.0"
    }
  }
  DATA
  example <<-DATA
  401 ERROR RESPONSE:
  {
    "errors": ["Nil JSON web token"]
  }
  DATA
  example <<-DATA
  422 ERROR RESPONSE
  {
    "errors": [
      {
        "title": "Invalid name",
        "detail": "Name can't be blank",
        "source": {}
      }
    ],
    "jsonapi": {
      "version": "1.0"
    }
  }
  DATA
  def create
    project = V1::ProjectForm.new(project_params)
    if project.save
      render jsonapi: project.object, class: ->(_) { V1::SerializableProject }, status: :created
    else
      render jsonapi_errors: project.errors, status: :unprocessable_entity
    end
  end

  api :PUT, 'v1/users/:user_id/projects/:id', 'Update project. Authorization token required.'
  error code: 401, desc: 'Invalid authorization token provided.'
  param :name, String, desc: 'name'
  example <<-DATA
  REQUEST:
  {
    "name": "Updated project"
  }
  DATA
  example <<-DATA
  RESPONSE
  {
    "data": {
      "id": "dab457d2-512c-41a5-8261-99c5d2967f31",
      "type": "project",
      "attributes": {
        "name": "Updated project"
      },
      "relationships": {
        "user": {
          "links": {
            "related": "/api/v1/users/f09d9fed-dea1-4efb-811a-dd8692b8f5ca"
          }
        }
      },
      "links": {
        "self": "/api/v1/users/f09d9fed-dea1-4efb-811a-dd8692b8f5ca/projects/dab457d2-512c-41a5-8261-99c5d2967f31"
      }
    },
    "jsonapi": {
      "version": "1.0"
    }
  }
  DATA
  example <<-DATA
  401 ERROR RESPONSE:
  {
    "errors": ["Nil JSON web token"]
  }
  DATA
  def update
    if @project.update(project_params)
      render jsonapi: @project, class: ->(_) { V1::SerializableProject }, status: :ok
    else
      render jsonapi_errors: @project.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, 'v1/users/:user_id/projects/:id', 'Delete project. Authorization token required.'
  def destroy
    if @project.destroy
      head :no_content, status: :ok
    else
      render jsonapi_errors: @project.errors, status: :unprocessable_entity
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.permit(%i[name user_id])
  end
end
