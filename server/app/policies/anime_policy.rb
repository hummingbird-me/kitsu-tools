class AnimePolicy < ApplicationPolicy
  def show?
    if user && !user.sfw_filter?
      true
    else
      record.sfw?
    end
  end

  def create?
    user && user.has_role?(:admin, Anime)
  end
  alias_method :update?, :create?
  alias_method :destroy?, :create?

  class Scope < Scope
    def resolve
      scope
    end
  end
end
