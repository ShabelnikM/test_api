class ProjectPolicy < ApplicationPolicy

  def index?
    record.user == user
  end

  def show?
    record.user == user
  end

  def update?
    record.user == user
  end

  def destroy?
    record.user == user
  end
end
