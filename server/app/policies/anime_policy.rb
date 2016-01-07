class AnimePolicy < ApplicationPolicy
  def show?
    if user && !user.sfw_filter?
      true
    else
      record.sfw?
    end
  end
end
