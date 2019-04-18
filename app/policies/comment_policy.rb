class CommentPolicy < ApplicationPolicy

  def index?
    record.task.project.user == user
  end

  def create?
    record.task.project.user == user
  end

  def destroy?
    record.task.project.user == user
  end
end
