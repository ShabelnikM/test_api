class V1::SerializableProject < JSONAPI::Serializable::Resource
  type 'project'

  attributes :name

  belongs_to :user do
    link :related do
      @url_helpers.v1_user_url(@object.user.id, only_path: true)
    end
  end

  link :self do
    @url_helpers.v1_user_project_url(@object.user.id, @object.id, only_path: true)
  end
end
