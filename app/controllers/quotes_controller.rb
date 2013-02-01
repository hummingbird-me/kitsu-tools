class QuotesController < ApplicationController
  def index
    @anime = Anime.find(params[:anime_id])
    @quotes = @anime.quotes
  end

  def new
    authenticate_user!
    @anime = Anime.find(params[:anime_id])
    @quote = Quote.new
    @quote.anime = @anime
  end

  def create
    authenticate_user!
    @anime = Anime.find(params[:anime_id])
    @quote = Quote.new
    @quote.content = params["quote"]["content"]
    @quote.character_name = params["quote"]["character_name"]
    @quote.anime = @anime
    @quote.save
    redirect_to anime_quotes_path(@anime)
  end
end
