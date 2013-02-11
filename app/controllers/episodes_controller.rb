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
    @watchlist = Watchlist.find_or_create_by_anime_id_and_user_id(@anime.id, current_user.id)

    if params[:watched] == "true"
      ev = EpisodeView.where(anime_id: @anime.id, user_id: current_user.id, episode_id: @episode.id).first
      if ev.nil?
        EpisodeView.create(anime: @anime, user: current_user, episode: @episode)
        @watchlist.episodes_watched += 1; @watchlist.save
      end
    elsif params[:watched] == "false"
      EpisodeView.where(anime_id: @anime.id, user_id: current_user.id, episode_id: @episode.id).delete_all
      @watchlist.episodes_watched -= 1; @watchlist.save
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
