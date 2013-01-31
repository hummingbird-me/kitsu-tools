class AnimesController < ApplicationController
  def show
    @anime = Anime.find(params[:id])
    @genres = @anime.genres
    @producers = @anime.producers
    @quotes = @anime.quotes.limit(4).includes(:character)
    @castings = @anime.castings.includes(:character, :voice_actor)

    respond_to do |format|
      format.html { render :show }
    end
  end
end
