class EpisodesController < ApplicationController
  include EpisodesHelper
  
  def index
    @anime = Anime.find(params[:anime_id])
    @episodes = @anime.episodes
  end
     
  def watch
    authenticate_user!
    
    @anime = Anime.find(params[:anime_id])
    @episode = Episode.find(params[:id])

    @watchlist = Watchlist.where(anime_id: @anime, user_id: current_user).first || Watchlist.create(anime: @anime, user: current_user, status: "Currently Watching")

    if params[:watched] == "true"
      if !@watchlist.episodes.include? @episode
        @watchlist.episodes << @episode
        if @watchlist.episodes == @watchlist.anime.episodes
          @watchlist.status = "Completed"
        end
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
          @episodes = select_four_episodes(@watchlist)
          render "episodes/replace_episodes"
        end
      end
      format.html { redirect_to :back }
    end
  end
end
