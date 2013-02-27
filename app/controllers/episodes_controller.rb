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
      ev = EpisodeView.where(anime_id: @anime.id, user_id: current_user.id, episode_id: @episode.id).first
      if ev.nil?
        EpisodeView.create(anime: @anime, user: current_user, episode: @episode)
        @watchlist.episodes_watched += 1
        # If this is the last episode, set the status to completed.
        if @anime.episode_count == @watchlist.episodes_watched
          @watchlist.status = "Completed"
        end
        @watchlist.save
      end
    elsif params[:watched] == "false"
      EpisodeView.where(anime_id: @anime.id, user_id: current_user.id, episode_id: @episode.id).delete_all
      @watchlist.episodes_watched -= 1
      # If the user removes an episode from a completed show, move it into the
      # "Currently Watching" list.
      if @watchlist.status = "Completed"
        @watchlist.status = "Currently Watching"
      end
      @watchlist.save
    end

    respond_to do |format|
      if request.xhr?
        format.js do 
          @episodes = select_four_episodes(@anime, current_user)
          render "episodes/replace_episodes"
        end
      end
      format.html { redirect_to :back }
    end
  end
end
