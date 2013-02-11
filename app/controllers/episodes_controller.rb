class EpisodesController < ApplicationController
  def index
    @anime = Anime.find(params[:anime_id])
    @episodes = @anime.episodes
  end
     
  def watch
    authenticate_user!
    
    @anime = Anime.find(params[:anime_id])
    @episode = Episode.find(params[:id])

    if params[:watched] == "true"
      ev = EpisodeView.where(anime_id: @anime.id, user_id: current_user.id, episode_id: @episode.id).first
      if ev.nil?
        EpisodeView.create(anime: @anime, user: current_user, episode: @episode)
      end
    else
      EpisodeView.where(anime_id: @anime.id, user_id: current_user.id, episode_id: @episode.id).delete_all
    end

    redirect_to :back
  end
end
