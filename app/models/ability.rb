class Ability
  include CanCan::Ability

  def initialize(user)
    # Global permissions
    can :read, Watchlist, :private => false

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

