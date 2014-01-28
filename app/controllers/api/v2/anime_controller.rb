module Api::V2
  class AnimeController < ApiController
    def show
      anime = Anime.find(params[:id])
      render json: present_anime(anime)
    end
  end
end
