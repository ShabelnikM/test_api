# frozen_string_literal: true
class V1::ProjectForm
  include ActiveModel::Model
  include Virtus.model

  attribute :name, String
  attribute :user_id, String

  validates :name, presence: true

  def save
    if valid?
      @object = Project.create!(name: name, user_id: user_id)
      true
    else
      false
    end
  end

  def object
    @object
  end
end
