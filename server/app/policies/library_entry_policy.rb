class LibraryEntryPolicy < ApplicationPolicy
  def show?
    # Yes, if you own it or are admin
    return true if record.user == user || user.has_role?(:admin)
    # No, if it's private
    return false if record.private?
    # No, if it's nsfw and you're not a perv
    return false if user.sfw_filter? && record.anime.nsfw?
    # Otherwise, yeah
    true
  end

  def create?
    return false unless user
    record.user == user || user.has_role?(:admin)
  end
  alias_method :update?, :create?
  alias_method :destroy?, :create?

  class Scope < Scope
    def resolve
      return scope.where(private: false) unless user
      t = LibraryEntry.arel_table
      private, user_id = t[:private], t[:user_id]
      # RAILS-5: This can be replaced with a simple ActiveRecord.or
      # (private == true && user == owner) || private == false
      scope.where(
        private.eq(false).or(
          user_id.eq(user.id).and(private.eq(true))
        )
      )
    end
  end
end
