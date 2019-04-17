# frozen_string_literal: true
class V1::TaskForm <  V1::ApplicationForm
  attribute :id, String
  attribute :name, String
  attribute :project_id, String
  attribute :deadline, DateTime
  attribute :priority, Integer
  attribute :done, Boolean
  attribute :change_priority, String

  validates :name, presence: true
  validate :deadline_present

  def initialize(attr = {})
    if attr[:id].nil?
      super(attr)
    else
      @task = Task.find(attr[:id])
      self[:name] = attr[:name].nil? ? @task.name : attr[:name]
      self[:deadline] = attr[:deadline].nil? ? @task.deadline : attr[:deadline]
      self[:done] = attr[:done].nil? ? @task.done : attr[:done]
      self[:priority] = @task.priority
      self[:change_priority] = attr[:change_priority].nil? ? nil : attr[:change_priority]
    end
  end

  def save
    if valid?
      @object = Task.create!(name: name, project_id: project_id, deadline: deadline&.to_datetime, priority: set_priority)
      true
    else
      false
    end
  end

  def update
    if valid?
      @task.update!(name: name, deadline: deadline.to_datetime, priority: update_priority, done: done)
      @object = Task.find(@task.id)
      true
    else
      false
    end
  end

  private

  def deadline_present
    if deadline && deadline <= Time.now
      errors.add(:deadline, 'should be present date')
    end
  end

  def set_priority
    prev_task = Project.find(project_id).tasks.last
    prev_task ? prev_task.priority + 1 : 0
  end

  def update_priority
    case change_priority
    when 'up' then priority - 1
    when 'down' then priority + 1
    else
      priority
    end
  end
end
