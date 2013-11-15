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


      # TEMPORARY: Library Status.
      new_watchlist_status = params[:anime]["library_status"]
      if new_watchlist_status.nil?
        # Delete watchlist.
        watchlist = Watchlist.find_or_create_by_anime_id_and_user_id(anime.id, current_user.id)
        watchlist.destroy
      else
        watchlist = Watchlist.find_or_create_by_anime_id_and_user_id(anime.id, current_user.id)
        Substory.from_action({
          user_id: current_user.id,
          action_type: "watchlist_status_update",
          anime_id: anime.slug,
          old_status: watchlist.status,
          new_status: new_watchlist_status,
          time: Time.now
        })
        watchlist.status = new_watchlist_status
        watchlist.save
      end

      render json: anime
    end
  end
end
