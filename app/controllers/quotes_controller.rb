class QuotesController < ApplicationController
  def index
    @anime = Anime.find(params[:anime_id])
    @quotes = @anime.quotes
  end
end
