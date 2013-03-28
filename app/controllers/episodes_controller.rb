class EpisodesController < ApplicationController
  include EpisodesHelper
  
  def index
    @anime = Anime.find(params[:anime_id])
    @episodes_watched = Hash.new(false)

    if user_signed_in?
      @watchlist = current_user.watchlists.where(anime_id: @anime).first
      if @watchlist
        @watchlist.episodes.each do |episode|
          @episodes_watched[ episode.id ] = true
        end
      end
    end
    @episodes = @anime.episodes.order(:season_number, :number).map {|e| [e, @episodes_watched[e.id]] }
  end
  
  # Private: Return a watchlist for the given anime,user pair. If there is no such
  #          watchlist, create one and return it.
  def get_watchlist(anime, user)
    Watchlist.where(anime_id: anime, user_id: user).first || Watchlist.create(anime: anime, user: user, status: "Currently Watching")
  end
     
  def watch
    authenticate_user!
    
    @anime = Anime.find(params[:anime_id])
    @episode = Episode.find(params[:id])

    @watchlist = get_watchlist(@anime, current_user)

    if params[:watched] == "true"
      if !@watchlist.episodes.include? @episode
        @watchlist.episodes << @episode
        current_user.update_life_spent_on_anime(@episode.length)
      end
    elsif params[:watched] == "false"
      @watchlist.episodes.delete @episode
      # If the user removes an episode from a completed show, move it into the
      # "Currently Watching" list.
      if @watchlist.status == "Completed"
        @watchlist.status = "Currently Watching"
      end
      current_user.update_life_spent_on_anime(-@episode.length)
    end
    @watchlist.last_watched = Time.now
    @watchlist.save

    respond_to do |format|
      if request.xhr?
        format.js do 
          @episodes = select_four_episodes(@watchlist, @anime)
          render "episodes/replace_episodes"
        end
      end
      format.html { redirect_to :back }
    end
  end

  def bulk_update
    authenticate_user!
    episode_count = params[:episode_count].to_i
    if episode_count
      @anime = Anime.find(params[:anime_id])
      @watchlist = get_watchlist(@anime, current_user)
      @anime.episodes.order(:season_number, :number).limit(episode_count).each do |episode|
        @watchlist.episodes << episode unless @watchlist.episodes.exists?(id: episode.id)
        @watchlist.last_watched = Time.now
        current_user.update_life_spent_on_anime(episode.length)
      end
      @watchlist.save
    end
    redirect_to :back
  end
end
