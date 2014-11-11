module Api::V2
  class AnimeController < ApiController
    def show
      anime = Anime.find(params[:id])
      render json: AnimeSerializer.new(anime).as_json
    end
  end
end
