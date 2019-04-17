# frozen_string_literal: true
class V1::TasksController < V1::ApplicationController
  before_action :authorize_request
  before_action :set_task, only: %i[show update destroy]

  api :GET, 'v1/projects/:project_id/tasks', 'Show project tasks. Authorization token required.'
  error code: 401, desc: 'Invalid authorization token provided.'
  example <<-DATA
  RESPONSE
  {
    "data": [
      {
        "id": "2371bde2-a95f-4e17-b866-eaa7ae8bcb20",
        "type": "task",
        "attributes": {
          "name": "Test task",
          "deadline": null,
          "done": false
        },
        "relationships": {
          "project": {
            "links": {
              "related": "/api/v1/users/f09d9fed-dea1-4efb-811a-dd8692b8f5ca/projects/003b9e56-a041-4819-9c3d-dda57e37f0a2"
            }
          }
        },
        "links": {
          "self": "/api/v1/projects/003b9e56-a041-4819-9c3d-dda57e37f0a2/tasks/2371bde2-a95f-4e17-b866-eaa7ae8bcb20"
        }
      },
      {
        "id": "e7d34ad0-2bb8-4a78-a17c-f0a693993fe8",
        "type": "task",
        "attributes": {
          "name": "Test task",
          "deadline": null,
          "done": false
        },
        "relationships": {
          "project": {
            "links": {
              "related": "/api/v1/users/f09d9fed-dea1-4efb-811a-dd8692b8f5ca/projects/003b9e56-a041-4819-9c3d-dda57e37f0a2"
            }
          }
        },
        "links": {
          "self": "/api/v1/projects/003b9e56-a041-4819-9c3d-dda57e37f0a2/tasks/e7d34ad0-2bb8-4a78-a17c-f0a693993fe8"
        }
      },
      {
        "id": "3d80ede2-ab33-481d-92fa-3c8d171b4fa6",
        "type": "task",
        "attributes": {
          "name": "Test task",
          "deadline": null,
          "done": false
        },
        "relationships": {
          "project": {
            "links": {
              "related": "/api/v1/users/f09d9fed-dea1-4efb-811a-dd8692b8f5ca/projects/003b9e56-a041-4819-9c3d-dda57e37f0a2"
            }
          }
        },
        "links": {
          "self": "/api/v1/projects/003b9e56-a041-4819-9c3d-dda57e37f0a2/tasks/3d80ede2-ab33-481d-92fa-3c8d171b4fa6"
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
    render jsonapi: Project.find(params[:project_id]).tasks.order('created_at DESC, priority ASC'),
           class: ->(_) { V1::SerializableTask },
           status: :ok
  end

  api :GET, 'v1/projects/:project_id/tasks/:id', 'Show task. Authorization token required.'
  error code: 401, desc: 'Invalid authorization token provided.'
  example <<-DATA
  RESPONSE
  {
    "data": {
      "id": "2371bde2-a95f-4e17-b866-eaa7ae8bcb20",
      "type": "task",
      "attributes": {
        "name": "Test task",
        "deadline": null,
        "done": false
      },
      "relationships": {
        "project": {
          "links": {
            "related": "/api/v1/users/f09d9fed-dea1-4efb-811a-dd8692b8f5ca/projects/003b9e56-a041-4819-9c3d-dda57e37f0a2"
          }
        }
      },
      "links": {
        "self": "/api/v1/projects/003b9e56-a041-4819-9c3d-dda57e37f0a2/tasks/2371bde2-a95f-4e17-b866-eaa7ae8bcb20"
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
  def show
    render jsonapi: @task, class: ->(_) { V1::SerializableTask }, status: :ok
  end

  api :POST, 'v1/projects/:project_id/tasks', 'Create new task. Authorization token required.'
  error code: 401, desc: 'Invalid authorization token provided.'
  error code: 422, desc: 'Invalid params.'
  param :name, String, desc: 'name'
  param :deadline, String, desc: 'datetime for deadline'
  example <<-DATA
  REQUEST:
  {
    "name": "Test task"
  }
  DATA
  example <<-DATA
  RESPONSE
  {
    "data": {
      "id": "2371bde2-a95f-4e17-b866-eaa7ae8bcb20",
      "type": "task",
      "attributes": {
        "name": "Test task",
        "deadline": null,
        "done": false
      },
      "relationships": {
        "project": {
          "links": {
            "related": "/api/v1/users/f09d9fed-dea1-4efb-811a-dd8692b8f5ca/projects/003b9e56-a041-4819-9c3d-dda57e37f0a2"
          }
        }
      },
      "links": {
        "self": "/api/v1/projects/003b9e56-a041-4819-9c3d-dda57e37f0a2/tasks/2371bde2-a95f-4e17-b866-eaa7ae8bcb20"
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
    task = V1::TaskForm.new(task_params)
    if task.save
      render jsonapi: task.object, class: ->(_) { V1::SerializableTask }, status: :created
    else
      render jsonapi_errors: task.errors, status: :unprocessable_entity
    end
  end

  api :PUT, 'v1/projects/:project_id/tasks/:id', 'Update task. Authorization token required.'
  error code: 401, desc: 'Invalid authorization token provided.'
  param :name, String, desc: 'name'
  param :deadline, String, desc: 'datetime for deadline'
  param :done, %w[true false], desc: 'task completed or not'
  param :priority, %w[up down], desc: 'up or down task priority'
  example <<-DATA
  REQUEST:
  {
    "name": "updated name",
    "deadline": "2019-04-19 02:17:25 +0300",
    "done": "true",
    "change_priority": "up"
  }
  DATA
  example <<-DATA
  RESPONSE
  {
    "data": {
      "id": "2371bde2-a95f-4e17-b866-eaa7ae8bcb20",
      "type": "task",
      "attributes": {
        "name": "updated name",
        "deadline": "2019-04-18T23:17:25.000Z",
        "done": true
      },
      "relationships": {
        "project": {
          "links": {
            "related": "/api/v1/users/f09d9fed-dea1-4efb-811a-dd8692b8f5ca/projects/003b9e56-a041-4819-9c3d-dda57e37f0a2"
          }
        }
      },
      "links": {
        "self": "/api/v1/projects/003b9e56-a041-4819-9c3d-dda57e37f0a2/tasks/2371bde2-a95f-4e17-b866-eaa7ae8bcb20"
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
  def update
    task = V1::TaskForm.new(task_params.merge(id: @task.id))
    if task.update
      render jsonapi: task.object, class: ->(_) { V1::SerializableTask }, status: :ok
    else
      render jsonapi_errors: task.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, 'v1/projects/:project_id/tasks/:id', 'Delete task. Authorization token required.'
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
    if @task.destroy
      head :no_content, status: :ok
    else
      render jsonapi_errors: @task.errors, status: :unprocessable_entity
    end
  end

  private

  def set_task
    @task = authorize Task.find(params[:id])
  end

  def task_params
    params.permit(%i[name project_id deadline done change_priority])
  end
end
