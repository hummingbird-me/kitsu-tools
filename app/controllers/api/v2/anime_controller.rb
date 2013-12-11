module Api::V2
  class AnimeController < ApiController
    def index
      anime = Anime.where(slug: params[:ids])
      render json: anime
    end

    def show
      anime = Anime.find(params[:id])
      render json: anime
    end
  end
end
