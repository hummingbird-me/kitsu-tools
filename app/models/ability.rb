class Ability
  include CanCan::Ability

  def initialize(user)
    # Global permissions
    can :read, Watchlist, :private => false

    # FIXME? Can users always see their own stories?
    #if user.nil? or user.sfw_filter
    #  can :read, Story, Story.where("NOT adult").joins("LEFT OUTER JOIN watchlists ON watchlists.id = stories.watchlist_id").where("watchlists.id IS NULL OR watchlists.private = 'f'") do |story|
    #    !story.adult and (story.watchlist.nil? or !story.watchlist.private)
    #  end
    #else
    #  can :read, Story, Story.joins("LEFT OUTER JOIN watchlists ON watchlists.id = stories.watchlist_id").where("watchlists.id IS NULL OR watchlists.private = 'f'") do |story|
    #    story.watchlist.nil? or !story.watchlist.private
    #  end
    #end

    if user.nil? or user.sfw_filter
      # Guests and people with the SFW filter on can see only non-sexual
      # content.
      can :read, Anime, "age_rating <> 'R18+' OR age_rating IS NULL" do |anime|
        anime.age_rating != 'R18+'
      end
    else
      can :read, Anime
    end
    
    if user.nil?
      ### Guest permissions
    else
      ### Regular user permissions
      can :read, Watchlist, :private => true, :user_id => user.id

      can :update, User, :id => user.id
    end
  end
end

