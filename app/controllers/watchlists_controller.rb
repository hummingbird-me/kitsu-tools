class WatchlistsController < ApplicationController
  before_filter :authenticate_user!

  def update_watchlist
    @anime = Anime.find(params["anime_id"])
    @watchlist = Watchlist.find_or_create_by_anime_id_and_user_id(@anime.id, current_user.id)
  end

  def update
    @anime = Anime.find(params["watchlist"]["anime_id"])
    @watchlist = Watchlist.find_or_create_by_anime_id_and_user_id(@anime.id, current_user.id)

    # Update status.
    @watchlist.status = params["watchlist"]["status"]
    
    # Update rating.
    @watchlist.rating = params["watchlist"]["rating"] || params["watchlist_rating_#{@anime.slug}"]
    @watchlist.rating = [[@watchlist.rating, -2].max, 2].min if @watchlist.rating
    
    # Update episodes watched.
    episode_count = [0, params["watchlist"]["episodes_watched"].to_i].max
    if episode_count != @watchlist.episodes_watched
      @anime.episodes.order(:season_number, :number).limit(episode_count).each do |episode|
        unless @watchlist.episodes.exists?(id: episode.id)
          @watchlist.episodes << episode
          @watchlist.last_watched = Time.now
          current_user.update_life_spent_on_anime(episode.length)
        end
      end
      @watchlist.save
    end

    @watchlist.save
    redirect_to :back
  end
  def create; update; end

  def remove_from_watchlist
    @anime = Anime.find(params["anime_id"])
    @watchlist = Watchlist.find_or_create_by_anime_id_and_user_id(@anime.id, current_user.id)
    @watchlist.destroy
    respond_to do |format|
      format.json { render :json => true }
      format.html { redirect_to :back }
    end
  end

  def update_rating
    @anime = Anime.find(params[:anime_id])
    @watch = Watchlist.find_or_create_by_anime_id_and_user_id(@anime.id, current_user.id)

    if params[:rating] == "nil"
      @watch.rating = nil
      @watch.save
    else
      rating = params[:rating].to_i
      if rating <= 2 and rating >= -2
        @watch.rating = rating
        if rating == -2 and !current_user.star_rating
          @watch.status ||= "Dropped"
        end
        @watch.status ||= "Currently Watching"
        @watch.save
      end
    end

    respond_to do |format|
      if request.xhr?
        format.js { render "replace_card" }
      end
      format.html { redirect_to :back }
    end
  end
end
