class CharacterPolicy < ApplicationPolicy
  def create?
    user && user.has_role?(:admin, Character)
  end
  alias_method :update?, :create?
  alias_method :destroy?, :create?

  class Scope < Scope
    def resolve
      scope
    end
  end
end
