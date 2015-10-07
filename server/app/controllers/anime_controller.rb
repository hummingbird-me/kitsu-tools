class AnimeController < ApplicationController
  def show
    @anime = Anime.find(params[:id])
    render json: @anime
  end

  def create
    @anime = deserialize(create: true)
    authorize @anime
    save_or_error! @anime
  end

  def update
    @anime = deserialize
    validate_id(@anime) || return
    save_or_error! @anime
  end

  def destroy
    @anime = Anime.find(params[:id])
    @anime.delay.destroy
  end
end
