class AnimePolicy < ApplicationPolicy
  def show?
    if user && !user.sfw_filter?
      true
    else
      record.sfw?
    end
  end

  class Scope < Scope
    def resolve
      if user && !user.sfw_filter?
        scope
      else
        scope.sfw
      end
    end
  end
end
