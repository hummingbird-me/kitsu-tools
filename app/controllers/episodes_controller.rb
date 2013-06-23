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
     
  ##
  ## DEPRECATED!
  ##
  def watch
    authenticate_user!
    
    @anime = Anime.find(params[:anime_id])
    @episode = Episode.find(params[:id])

    @watchlist = get_watchlist(@anime, current_user)

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
end
