class V1::SerializableTask < JSONAPI::Serializable::Resource
  type 'task'

  attributes :name, :deadline, :done

  belongs_to :project do
    link :related do
      @url_helpers.v1_user_project_url(@object.project.user.id, @object.project.id, only_path: true)
    end
  end

  link :self do
    @url_helpers.v1_project_task_url(@object.project.id, @object.id, only_path: true)
  end
end
