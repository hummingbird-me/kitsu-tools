class EpisodesController < ApplicationController
  def index
    respond_to do |format|
      format.html do
        @anime = Anime.find(params[:anime_id])
        preload_to_ember! @anime, serializer: FullAnimeSerializer,
                                  root: 'full_anime'
        render 'anime/show', layout: 'redesign'
      end
      format.json do
        episodes = Episode.page(params[:page]).per(20).includes(:anime)
        anime = Anime.find params[:anime_id]
        episodes = episodes.where(anime_id: anime.id)
        render json: episodes, meta: { cursor: 1 + (params[:page] || 1).to_i }
      end
    end
  end

  def show
    @episode = Episode.find(params[:id])
    @anime = @episode.anime

    respond_to do |format|
      format.html do
        preload_to_ember! @anime, serializer: FullAnimeSerializer,
                                  root: 'full_anime'
        preload_to_ember! @episode

        render 'anime/show', layout: 'redesign'
      end
    end
  end
end
