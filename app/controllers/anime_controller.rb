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

  def filtered_listing
    @filter = params[:filter]
    if @filter == "all"
      @anime = Anime.page(params[:page]).per(18)
    else
      raise ""
    end

    @genres = Genre.all

    if not user_signed_in?
      @watchlist = [false] * @anime.length
    else
      @watchlist = @anime.to_a.map do |x|
        Watchlist.where(:anime_id => x, :user_id => current_user).first
      end
    end

    respond_to do |format|
      format.html { render :index }
    end
  end
end
