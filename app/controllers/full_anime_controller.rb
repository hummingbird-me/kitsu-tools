class FullAnimeController < ApplicationController
  def show
    anime = Anime.find params[:id]
    render json: anime, serializer: FullAnimeSerializer
  end
end
