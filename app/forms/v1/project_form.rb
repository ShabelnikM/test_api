# frozen_string_literal: true
class V1::ProjectForm <  V1::ApplicationForm
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
end
