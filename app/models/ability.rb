class Ability
  include CanCan::Ability

  def initialize(user)
    # Global permissions
    can :read, Watchlist, :private => false

    can :read, Story, Story.joins("LEFT OUTER JOIN watchlists ON watchlists.id = stories.watchlist_id").where("watchlists.id IS NULL OR watchlists.private = 'f'") do |story|
      story.watchlist.nil? or !story.watchlist.private
    end
    
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

      if user.admin?
        ### Admin permissions
        can :update, Anime
        can :moderate, :forum
      end
    end
  end
end

