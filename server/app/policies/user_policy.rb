class UserPolicy < ApplicationPolicy
  def show?
    true
  end

  def create?
    true
  end

  def update?
    user == record || is_admin?
  end

  def destroy?
    is_admin?
  end
end
