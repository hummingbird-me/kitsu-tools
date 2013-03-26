class QuotesController < ApplicationController
  def index
    @anime = Anime.find(params[:anime_id])
    if user_signed_in?
      @watchlist = current_user.watchlists.where(anime_id: @anime).first
    end
    @quotes = Quote.includes(:user).find_with_reputation(:votes, :all, {:conditions => ["anime_id = ?", @anime.id], :order => "votes DESC"})
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
    @quote.user = current_user
    @quote.save
    redirect_to anime_quotes_path(@anime)
  end

  def vote
    authenticate_user!
    @quote = Quote.find(params[:id])
    if params[:type] == "up"
      @quote.add_or_update_evaluation(:votes, 1, current_user)
    else
      @quote.delete_evaluation(:votes, current_user)
    end

    respond_to do |format|
      if request.xhr?
        format.js { render "replace_votes" }
      end
      format.html { redirect_to :back }
    end
  end
end
