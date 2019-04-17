class TaskPolicy < ApplicationPolicy

  def index?
    record.project.user == user
  end

  def show?
    record.project.user == user
  end

  def create?
    record.project.user == user
  end

  def update?
    record.project.user == user
  end

  def destroy?
    record.project.user == user
  end
end
