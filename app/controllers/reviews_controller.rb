class ReviewsController < ApplicationController
  def index
    @anime = Anime.find(params[:anime_id])
    @reviews = @anime.reviews.includes(:user)
  end
end
