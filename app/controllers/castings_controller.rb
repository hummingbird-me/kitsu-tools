class CastingsController < ApplicationController
  def index
    if params.key?(:anime_id)
      castings = Anime.find(params[:anime_id]).castings
    elsif params.key?(:manga_id)
      castings = Manga.find(params[:manga_id]).castings
    else
      return error! 'Missing anime or manga id', 400
    end
    render json: castings.includes(:character, :person)
  end
end
