class MALImportApplyWorker
  include Sidekiq::Worker

  def perform(user_id)
    @user = User.find(user_id)
    @staged_import = @user.staged_import
    unless @staged_import.nil? or !@staged_import.data[:complete]
      @watchlist = get_watchlist(@staged_import)
      @reviews   = get_reviews(@staged_import)
      
      @user.transaction do
        @reviews.each {|x| x.save }

        @watchlist.each do |x|
          wl = x[1]
          if wl.status != "Completed" and wl.episodes_watched > 0 and wl.anime.episodes.length > wl.episodes_watched
            wl.episodes = wl.anime.episodes.order(:number).limit(wl.episodes_watched)
          end
          wl.save
        end
        
        @user.staged_import = nil
        @user.save
        @user.recompute_life_spent_on_anime
      end
    end
  end

  # NOTE This code is duplicated in the controller.
  def get_watchlist(staged_import)
    @watchlist = []

    @animes = {}
    Anime.where(:mal_id => staged_import["data"][:watchlist].map {|x| x[:mal_id] }).each {|a| @animes[a.mal_id] = a }
    
    staged_import["data"][:watchlist].each do |w|
      anime = @animes[ w[:mal_id].to_i ]
      if anime
        watchlist = Watchlist.where(user_id: staged_import.user, anime_id: anime).first || false
        if !watchlist or watchlist.updated_at < w[:last_updated]
          watchlist = Watchlist.new(status: w[:status], episodes_watched: w[:episodes_watched], updated_at: w[:last_updated], user: staged_import.user, anime: anime, imported: true)
          if w[:rating] != '0'
            mal_rating = w[:rating].to_i rescue 5
            mal_rating = ((((mal_rating - 1) / 9.0) - 0.5) * 2 * 2).round
            mal_rating = [-2, [2, mal_rating].min].max # Fit it inside -2,2 if
                                                       # it is out of bounds.
            watchlist.rating = mal_rating
          end
        end
        @watchlist.push( [anime, watchlist] )
      end
    end

    return @watchlist
  end
  
  # NOTE This code is duplicated in the controller.
  def get_reviews(staged_import)
    reviews = []
    staged_import["data"][:reviews].each do |rev|
      review = Review.new(user: staged_import.user, anime: Anime.find_by_mal_id(rev[:mal_id]), content: rev[:content], source: "mal_import")
      
      mal_rating = rev[:rating].to_i rescue 5
      mal_rating = ((((mal_rating - 1) / 9.0) - 0.5) * 2 * 2).round
      mal_rating = [-2, [2, mal_rating].min].max # Fit it inside -2, 2 if
                                                 # it is out of bounds.
      review.rating = mal_rating
      
      reviews.push review
    end
    reviews
  end
  
end
