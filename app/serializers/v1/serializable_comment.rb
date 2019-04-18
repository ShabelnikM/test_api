class V1::SerializableComment < JSONAPI::Serializable::Resource
  type 'comment'

  attributes :text

  attribute :image do
    Rails.application.routes.url_helpers.rails_blob_path(@object.image, only_path: true) if @object.image.attached?
  end

  belongs_to :task do
    link :related do
      @url_helpers.v1_project_task_url(@object.task.project.id, @object.task.id, only_path: true)
    end
  end
end
