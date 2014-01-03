class QuotesController < ApplicationController
  def index
    @anime = Anime.find(params[:anime_id])
    @watchlist = current_user.watchlists.where(anime_id: @anime).first if user_signed_in?
    @gallery = @anime.gallery_images.limit(4)
    
    # This query is potentially slow, investigate later.
    @users = @anime.watchlists.where(status: "Currently Watching").order("last_watched DESC").joins(:user).where('users.avatar_file_name IS NOT NULL').includes(:user).limit(9).map {|x| x.user }

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

    Substory.from_action({
      user_id: current_user,
      action_type: "submitted_quote",
      quote_id: @quote.id,
      time: Time.now
    })

    redirect_to anime_quotes_path(@anime)
  end

  def vote
    authenticate_user!
    @quote = Quote.find(params[:id])
    if params[:type] == "up"
      @quote.add_or_update_evaluation(:votes, 1, current_user)
      Substory.from_action({
        user_id: current_user.id,
        action_type: "liked_quote",
        quote_id: @quote.id,
        time: Time.now
      })
    else
      @quote.delete_evaluation(:votes, current_user)
      Substory.from_action({
        user_id: current_user.id,
        action_type: "unliked_quote",
        quote_id: @quote.id,
        time: Time.now
      })
    end

    respond_to do |format|
      if request.xhr?
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
      quote.add_or_update_evaluation(:votes, 1, current_user)
      Substory.from_action({
        user_id: current_user.id,
        action_type: "liked_quote",
        quote_id: quote.id,
        time: Time.now
      })
    else
      quote.delete_evaluation(:votes, current_user)
      Substory.from_action({
        user_id: current_user.id,
        action_type: "unliked_quote",
        quote_id: quote.id,
        time: Time.now
      })
    end

    render json: quote
  end
end
