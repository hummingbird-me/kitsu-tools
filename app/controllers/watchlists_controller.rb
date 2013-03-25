class WatchlistsController < ApplicationController
  before_filter :authenticate_user!

  def update
    @anime = Anime.find(params["watchlist"]["anime_id"])
    @watchlist = Watchlist.find_or_create_by_anime_id_and_user_id(@anime.id, current_user.id)

    # Update status.
    @watchlist.status = params["watchlist"]["status"]
    
    # Update rating.
    @watchlist.rating = params["watchlist"]["rating"]
    @watchlist.rating = [[@watchlist.rating, -2].max, 2].min
    
    # Update episodes watched.
    episode_count = [0, params["watchlist"]["episodes_watched"].to_i].max
    if episode_count
      @anime.episodes.order(:season_number, :number).limit(episode_count).each do |episode|
        @watchlist.episodes << episode unless @watchlist.episodes.exists?(id: episode.id)
        @watchlist.last_watched = Time.now
        current_user.update_life_spent_on_anime(episode.length)
      end
      @watchlist.save
    end

    @watchlist.save
    redirect_to :back
  end
  def new; update; end

  def add_to_watchlist
    @anime = Anime.find(params[:anime_id])
    @watch = Watchlist.find_or_create_by_anime_id_and_user_id(@anime.id, current_user.id)
    @watch.status = params[:status]
    @watch.save

    respond_to do |format|
      if request.xhr?
        format.js { render "replace_card" }
      end
      format.html { redirect_to :back }
    end
  end

  def remove_from_watchlist
    @anime = Anime.find(params[:anime_id])
    @watch = Watchlist.find_by_anime_id_and_user_id(@anime.id, current_user.id)
    @watch.delete
    @watch = false

    respond_to do |format|
      if request.xhr?
        format.js { render "replace_card" }
      end
      format.html { redirect_to :back }
    end
  end

  def update_rating
    @anime = Anime.find(params[:anime_id])
    @watch = Watchlist.find_or_create_by_anime_id_and_user_id(@anime.id, current_user.id)
    
    rating = params[:rating].to_i
    if rating <= 2 and rating >= -2
      @watch.rating = rating
      if rating == -2 and !current_user.star_rating
        @watch.status ||= "Dropped"
      end
      @watch.status ||= "Currently Watching"
      @watch.save
    end

    respond_to do |format|
      if request.xhr?
        format.js { render "replace_card" }
      end
      format.html { redirect_to :back }
    end
  end
end
