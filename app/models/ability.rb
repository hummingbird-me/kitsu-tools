class Ability
  include CanCan::Ability

  def initialize(user)
    if user.nil?
      ### Guest permissions
      # Can view non-hentai anime.
      can :read, Anime, "age_rating <> 'R18+'"
    elsif user.admin?
      ### Admin permissions
      can :manage, :all
    else
      ### Regular user permissions
      if user.sfw_filter
        can :read, Anime, "age_rating <> 'R18+'"
      else
        can :read, Anime
      end
    end
  end
end
