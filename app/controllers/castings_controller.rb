class CastingsController < ApplicationController
  def index
    anime = Anime.find(params[:anime_id])
    render json: anime.castings.includes(:character, :person)
  end
end
