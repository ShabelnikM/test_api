# frozen_string_literal: true
class V1::ApplicationForm
  include ActiveModel::Model
  include Virtus.model

  def object
    @object
  end
end
