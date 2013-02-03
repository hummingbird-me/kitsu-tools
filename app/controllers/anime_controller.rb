class AnimeController < ApplicationController
  def show
    @anime = Anime.find(params[:id])
    @genres = @anime.genres
    @producers = @anime.producers
    @quotes = @anime.quotes.limit(4)
    @castings = @anime.castings.includes(:character, :voice_actor)
    @reviews = @anime.reviews.includes(:user)

    respond_to do |format|
      format.html { render :show }
    end
  end

  def index
    # Fetch the watchlist
    @filter = params[:filter] || "all"
    if @filter == "all"

      @anime = Anime.page(params[:page]).per(18)
      if not user_signed_in?
        @watchlist = [false] * @anime.length
      else
        @watchlist = @anime.to_a.map do |x|
          Watchlist.where(:anime_id => x, :user_id => current_user).first
        end
      end

    elsif @filter == "unseen"

      authenticate_user!
      @watchlist = Watchlist.where(:user_id => current_user).includes(:anime)
      @watched = @watchlist.map(&:anime)
      if @watched.length == 0
        @anime = Anime
      else
        @anime = Anime.where('id NOT IN (?)', @watched.map(&:id))
      end
      @anime = @anime.page(params[:page]).per(18)
      @watchlist = [false] * @anime.length

    else
      raise ""
    end

    @genres = Genre.all


    respond_to do |format|
      format.html { render :index }
    end
  end
end
