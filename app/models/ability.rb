class Ability
  include CanCan::Ability

  def initialize(user)
    # Global permissions
    can :read, Watchlist, :private => false
    
    if user.nil?
      ### Guest permissions
      # Can view non-hentai anime.
      can :read, Anime, "age_rating <> 'R18+'"
    else
      ### Regular user permissions
      can :read, Watchlist, :private => true, :user_id => user.id

      can :update, User, :id => user.id
      
      if user.sfw_filter
        can :read, Anime, "age_rating <> 'R18+'"
      else
        can :read, Anime
      end
    end

    if user.admin?
      ### Admin permissions
      can :manage, :all
      can :moderate, :forum
    end
  end
end

