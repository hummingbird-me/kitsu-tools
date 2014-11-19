class QuotesController < ApplicationController
  def index
    @anime = Anime.find(params[:anime_id])
    @quotes = @anime.quotes.includes(:user).order('positive_votes DESC')

    respond_to do |format|
      format.html do
        preload_to_ember! @anime, serializer: FullAnimeSerializer, root: "full_anime"
        render_ember
      end
      format.json do
        render json: @quotes
      end
    end
  end

  def create
    authenticate_user!
    @anime = Anime.find(params["quote"]["anime_id"])
    @quote = Quote.new
    @quote.content = params["quote"]["content"]
    @quote.character_name = params["quote"]["character_name"]
    @quote.anime = @anime
    @quote.user = current_user
    @quote.save

    redirect_to anime_quotes_path(@anime)
  end

  def update
    authenticate_user!

    quote = Quote.find(params[:id])

    # Update favorite status.
    vote = Vote.for(current_user, quote)
    if params[:quote]["is_favorite"]
      if vote.nil?
        Vote.create(user: current_user, target: quote)
      end
    else
      unless vote.nil?
        vote.destroy!
      end
    end

    render json: quote.reload
  end
end
