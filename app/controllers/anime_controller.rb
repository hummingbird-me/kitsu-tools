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
    # Establish a base scope.
    @anime = Anime.page(params[:page]).per(18)

    # Get a list of all genres.
    @all_genres = Genre.order(:name)

    # Filter by genre if needed.
    if params[:genres] and params[:genres].length > 0
      @genre_slugs  = params[:genres].split.uniq 
      if @all_genres.count > @genre_slugs.length
        @genre_filter = Genre.where("slug IN (?)", @genre_slugs)
        @anime = @anime.joins(:genres)
                       .where("genres.id IN (?)", @genre_filter.map(&:id))
      end
    end

    # Fetch the user's watchlist.
    @watchlist = Hash.new(false)
    if user_signed_in?
      Watchlist.where(:user_id => current_user).each do |watch|
        @watchlist[ watch.anime_id ] = watch
      end
    end

    # What regular filter are we applying?
    @filter = params[:filter] || "all"

    if @filter == "unseen"

      # The user needs to be signed in for this one.
      authenticate_user!

      @anime = @anime.where('id NOT IN (?)', @watchlist.keys)

    else
      # The filter is either all or something invalid; either way we don't have
      # to do anything.
    end

    respond_to do |format|
      format.html { render :index }
    end
  end
end
