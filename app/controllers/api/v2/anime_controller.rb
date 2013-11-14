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

    def update
      anime = Anime.find(params[:id])

      # Update favorite status.
      favorite_status = params[:anime]["is_favorite"]
      if favorite_status and !current_user.has_favorite?(anime)
        # Add favorite.
        Favorite.create(user: current_user, item: anime)
      elsif current_user.has_favorite?(anime) and !favorite_status
        # Remove favorite.
        current_user.favorites.where(item_id: anime, item_type: "Anime").first.destroy
      end

      render json: anime
    end
  end
end
