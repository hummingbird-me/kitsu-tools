class GenrePolicy < ApplicationPolicy
  def create?
    user && user.has_role?(:admin, Genre)
  end
  alias_method :update?, :create?
  alias_method :destroy?, :create?

  class Scope < Scope
    def resolve
      scope
    end
  end
end
