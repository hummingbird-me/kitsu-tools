module Api::V2
  class AnimeController < ApiController
    def show
      anime = Anime.find(params[:id])
      render json: anime
    end

    def franchise
      anime = Anime.find(params[:anime_id])
      franchise = anime.franchises.map {|x| x.anime }.flatten.uniq.sort_by {|x| x.started_airing_date || (Time.now + 100.years).to_date }
      render json: franchise
    end
  end
end
