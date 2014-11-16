module Api::V2
  class AnimeController < ApiController
    caches_action :show, expires_in: 1.hour

    def show
      if params[:id].start_with? "myanimelist:"
        anime = Anime.find_by(mal_id: params[:id].split(':')[1])
      else
        anime = Anime.find(params[:id])
      end
      render json: AnimeSerializer.new(anime).as_json
    end
  end
end
