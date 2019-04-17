class V1::SerializableUser < JSONAPI::Serializable::Resource
  type 'user'

  attributes :username, :email

  link :self do
    @url_helpers.v1_user_url(@object.id, only_path: true)
  end
end
