class QuotesController < ApplicationController
  def index
    @anime = Anime.find(params[:anime_id])
    @quotes = Quote.includes(:creator).find_with_reputation(:votes, :all, {:conditions => ["anime_id = ?", @anime.id], :order => "votes DESC"})
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
    @quote.creator = current_user
    @quote.save
    redirect_to anime_quotes_path(@anime)
  end

  def vote
    authenticate_user!
    value = params[:type] == "up" ? 1 : 0
    @quote = Quote.find(params[:id])
    @quote.add_or_update_evaluation(:votes, value, current_user)
    redirect_to :back
  end
end
