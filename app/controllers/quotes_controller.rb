class QuotesController < ApplicationController
  def index
    @anime = Anime.find(params[:anime_id])
    @quotes = @anime.quotes.includes(:user).order('positive_votes DESC')

    preload_to_ember! @quotes

    render_ember
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
      vote = Vote.for(current_user, @quote)
      if vote.nil?
        Vote.create(user: current_user, target: @quote)
      end
    else
      vote = Vote.for(current_user, @quote)
      unless vote.nil?
        vote.destroy
      end
    end

    respond_to do |format|
      if request.xhr?
        @quote = @quote.reload
        format.js { render "replace_votes" }
      end
      format.html { redirect_to :back }
    end
  end

  def update
    authenticate_user!

    quote = Quote.find(params[:id])

    # Update favorite status.
    if params[:quote]["is_favorite"]
      vote = Vote.for(current_user, quote)
      if vote.nil?
        Vote.create(user: current_user, target: quote)
      end
    else
      vote = Vote.for(current_user, quote)
      unless vote.nil?
        vote.destroy
      end
    end

    render json: quote.reload
  end
end
