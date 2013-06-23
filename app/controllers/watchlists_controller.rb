class WatchlistsController < ApplicationController
  before_filter :authenticate_user!

  def update_watchlist
    @anime = Anime.find(params["anime_id"])
    @watchlist = Watchlist.find_or_create_by_anime_id_and_user_id(@anime.id, current_user.id)

    # Update status.
    if params[:status]
      status = Watchlist.status_parameter_to_status(params[:status])
      if @watchlist.status != status
        # Create an action if the status was changed.
        Substory.from_action({
          user_id: current_user.id,
          action_type: "watchlist_status_update",
          anime_id: @anime.slug,
          old_status: @watchlist.status,
          new_status: status,
          time: Time.now
        })
      end
      @watchlist.status = status if Watchlist.valid_statuses.include? status
    end
    
    # Update privacy.
    if params[:privacy]
      if params[:privacy] == "private"
        @watchlist.private = true
      elsif params[:privacy] == "public"
        @watchlist.private = false
      end
    end

    # Update rating.
    if params[:rating]
      if @watchlist.rating == params[:rating].to_i
        @watchlist.rating = nil
      else
        @watchlist.rating = [ [-2, params[:rating].to_i].max, 2 ].min
      end
    end

    # Update rewatched_times.
    if params[:rewatched_times]
      @watchlist.update_rewatched_times params[:rewatched_times]
    end

    # Update notes.
    if params[:notes]
      @watchlist.notes = params[:notes]
    end
    
    # Update episode count.
    if params[:episodes_watched]
      @watchlist.update_episode_count params[:episodes_watched]
    end

    if params[:increment_episodes]
      @watchlist.update_episode_count @watchlist.episodes_watched+1
      Substory.from_action({
        user_id: current_user.id,
        action_type: "watched_episode",
        anime_id: @anime.slug,
        episode_number: @watchlist.episodes_watched+1
      })
    end
    
    @watchlist.save
    
    render :json => @watchlist.to_hash(current_user)
  end

  def update
    @anime = Anime.find(params["watchlist"]["anime_id"])
    @watchlist = Watchlist.find_or_create_by_anime_id_and_user_id(@anime.id, current_user.id)

    # Update status.
    if @watchlist.status != params["watchlist"]["status"]
      Substory.from_action({
        user_id: current_user.id,
        action_type: "watchlist_status_update",
        anime_id: @anime.slug,
        old_status: @watchlist.status,
        new_status: params["watchlist"]["status"],
        time: Time.now
      })
    end
    @watchlist.status = params["watchlist"]["status"]
    
    # Update rating.
    @watchlist.rating = params["watchlist"]["rating"] || params["watchlist_rating_#{@anime.slug}"]
    @watchlist.rating = [[@watchlist.rating, -2].max, 2].min if @watchlist.rating
    
    # Update episodes watched.
    @watchlist.update_episode_count params["watchlist"]["episodes_watched"]

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
