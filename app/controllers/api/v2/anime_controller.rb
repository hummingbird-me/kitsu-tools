module Api::V2
  class AnimeController < ApiController
    caches_action :show, expires_in: 1.hour

    def show
      if params[:id].include? ','
        anime = params[:id].split(',').map {|id| find_anime(id) rescue nil }.compact
      else
        anime = find_anime(params[:id])
      end
      render json: Api::V2::AnimeSerializer.new(anime).as_json
    end

    private

    def find_anime(id)
      if id.respond_to?(:start_with?) && id.start_with?("myanimelist:")
        Anime.find_by(mal_id: id.split(':')[1]) ||
          raise(ActiveRecord::RecordNotFound)
      else
        Anime.find(id)
      end
    end
  end
end
