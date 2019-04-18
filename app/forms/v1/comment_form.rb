# frozen_string_literal: true
class V1::CommentForm < V1::ApplicationForm
  attribute :text, String
  attribute :task_id, String
  attribute :image, File

  validates :text, length: { minimum: 10, maximum: 256 }
  validates :image, file_size: { less_than_or_equal_to: 10.megabyte },
            file_content_type: { allow: %w[image/jpg image/jpeg image/png] }

  def save
    if valid?
      @object = Comment.create!(text: text, task_id: task_id, image: image)
      true
    else
      false
    end
  end
end