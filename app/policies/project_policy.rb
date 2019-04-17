class ProjectPolicy < ApplicationPolicy

  def show?
    true
  end

  def update?
    record.user == user
  end

  def destroy?
    record.user == user
  end
end
