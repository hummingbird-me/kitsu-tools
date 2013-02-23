class AnimeController < ApplicationController
  include EpisodesHelper
  
  def show
    @anime = Anime.find(params[:id])
    @genres = @anime.genres
    @producers = @anime.producers
    @quotes = @anime.quotes.limit(4)
    @reviews = @anime.reviews.includes(:user)
    @castings = Casting.where(anime_id: @anime.id, featured: true)
    @languages = @castings.map {|x| x.role }.uniq
    @gallery = GalleryImage.where(anime_id: @anime.id).limit(6)

    if user_signed_in?
      @watchlist = Watchlist.where(anime_id: @anime.id, user_id: current_user.id).first
    else
      @watchlist = false
    end

    # Get the list of episodes.
    if user_signed_in?
      @episodes = select_four_episodes(@anime, current_user)
    else
      @episodes = select_four_episodes(@anime, nil)
    end

    # Add to recently viewed.
    if @anime.sfw?
      session[:recently_viewed] ||= []
      session[:recently_viewed].delete( params[:id] )
      session[:recently_viewed].unshift( params[:id] )
      session[:recently_viewed].pop while session[:recently_viewed].length > 7
    end

    respond_to do |format|
      format.html { render :show }
    end
  end

  def index
    # Establish a base scope, with pagination enabled.
    @anime = Anime.sfw_filter(current_user).page(params[:page]).per(18)

    # Get a list of all genres.
    @all_genres = Genre.default_filterable(current_user)

    # Filter by genre if needed.
    if params[:genres] and params[:genres].length > 0
      @all_genre_slugs = @all_genres.map {|x| x.slug }
      @slugs_to_filter = params[:genres].split.uniq
      if @slugs_to_filter.length > 0
        @genre_filter = Genre.where("slug IN (?)", @slugs_to_filter)
        if @genre_filter.length > 10
          # There are more than 10 genres selected -- block the genres that
          # haven't been selected.
          @anime = @anime.exclude_genres(@all_genres - @genre_filter)
        else
          # 10 or fewer genres are enabled, search for all anime containing those
          # genres instead.
          @anime = @anime.include_genres(@genre_filter)
        end
      end
    end
    @genre_filter ||= @all_genres

    # Fetch the user's watchlist.
    if user_signed_in?
      @watchlist = current_user.watchlist_table
    else
      @watchlist = Hash.new(false)
    end


    # What regular filter are we applying?
    @filter = params[:filter] || "all"

    if @filter == "unseen"

      # The user needs to be signed in for this one.
      authenticate_user!

      # Get anime which the user doesn't have on their watchlist.
      @anime = @anime.where('anime.id NOT IN (?)', @watchlist.keys)
      
    elsif @filter == "unfinished"

      # FIXME: Filter out anime where the watchlist status is "Completed".
      @anime = @anime.where('anime.id IN (?)', @watchlist.keys)

    elsif @filter == "recommended"

      # The user needs to be signed in.
      authenticate_user!

      # Check whether we need to update the user's recommendations.
      new_watchlist_hash = Watchlist.watchlist_hash( @watchlist.values.map(&:id) )
      if current_user.watchlist_hash != new_watchlist_hash
        current_user.update_attributes(
          watchlist_hash: new_watchlist_hash,
          recommendations_up_to_date: false
        )
        RecommendingWorker.perform_async(current_user.id)
      end

      @anime = @anime.joins(:recommendations).where(:recommendations => {:user_id => current_user.id}).order('score DESC')

    else
      # We don't have to do any filtering.
    end

    # Order by Wilson CI lower bound, except for the recommendations page.
    unless @filter == "recommended"
      @anime = @anime.order('anime.wilson_ci DESC')
    end
    
    @collection = @anime.map {|x| [x, @watchlist[x.id]] }

    respond_to do |format|
      format.html { render :index }
    end
  end
end
