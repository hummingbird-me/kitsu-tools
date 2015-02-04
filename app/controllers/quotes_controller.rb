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

    quote_params = params.require(:quote).permit(:anime_id, :character_name, :content)

    anime = Anime.find(quote_params[:anime_id])
    quote = Quote.create(
      character_name: quote_params[:character_name],
      content: quote_params[:content],
      anime: anime,
      user: current_user
    )

    render json: quote
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
