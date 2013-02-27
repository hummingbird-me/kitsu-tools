class ImportsController < ApplicationController
  before_filter :authenticate_user!
  
  def myanimelist
    @user = current_user
    @user.mal_username = params["mal_username"]
    @user.save
    @staged_import = StagedImport.find_or_create_by_user_id(@user.id)
    @staged_import.data = {version: 1, complete: false}
    @staged_import.save
    MALImportWorker.perform_async(params["mal_username"], @staged_import.id)
    redirect_to :back
  end

  def get_watchlist(staged_import)
    @watchlist = []

    @animes = {}
    Anime.where(:mal_id => staged_import["data"][:watchlist].map {|x| x[:mal_id] }).each {|a| @animes[a.mal_id] = a }
    
    staged_import["data"][:watchlist].each do |w|
      anime = @animes[ w[:mal_id].to_i ]
      if anime
        watchlist = Watchlist.where(user_id: current_user, anime_id: anime).first || false
        if !watchlist or watchlist.updated_at < w[:last_updated]
          watchlist = Watchlist.new(status: w[:status], episodes_watched: w[:episodes_watched], updated_at: w[:last_updated])
          if w[:rating] != '0'
            mal_rating = w[:rating].to_i rescue 5
            mal_rating = ((((mal_rating - 1) / 9.0) - 0.5) * 2 * 2).round
            mal_rating = [-2, [2, mal_rating].min].max # Fit it inside -2,2 if
                                                       # it is out of bounds.
            watchlist.rating = mal_rating
          end
        end
        @watchlist.push( [anime, watchlist, 'three'] )
      end
    end

    return @watchlist
  end
  
  def get_reviews(staged_import)
    reviews = []
    staged_import["data"][:reviews].each do |rev|
      reviews.push Review.new(user: current_user, anime: Anime.find_by_mal_id(rev[:mal_id]), content: rev[:content])
    end
    reviews
  end
  
  def review
    @staged_import = current_user.staged_import
    if @staged_import.nil? or !@staged_import.data[:complete]
      redirect_to "/users/edit#import"
    else
      @watchlist = get_watchlist(@staged_import)
      @reviews = get_reviews(@staged_import)
    end
  end

  def cancel
    import = current_user.staged_import
    import.delete
    redirect_to :back
  end
end
