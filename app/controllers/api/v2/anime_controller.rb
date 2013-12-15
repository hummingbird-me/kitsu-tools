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

    def update
      authenticate_user!
      anime = Anime.find(params[:id])
      if current_user.admin?
        anime.synopsis = params[:anime][:synopsis]
        anime.episode_count = params[:anime][:episode_count]
        anime.episode_length = params[:anime][:episode_length]
        unless Rails.env.development?
          anime.poster_image = URI(params[:anime][:poster_image])
          anime.cover_image = URI(params[:anime][:cover_image])
        end
        anime.cover_image_top_offset = params[:anime][:cover_image_top_offset]
        anime.save
      end
      render json: anime
    end
  end
end
