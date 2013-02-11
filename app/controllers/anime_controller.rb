class AnimeController < ApplicationController
  def show
    @anime = Anime.find(params[:id])
    @genres = @anime.genres
    @producers = @anime.producers
    @quotes = @anime.quotes.limit(4)
    @castings = @anime.castings.includes(:character, :voice_actor)
    @reviews = @anime.reviews.includes(:user)

    if user_signed_in?
      @watchlist = Watchlist.where(anime_id: @anime.id, user_id: current_user.id).first
    else
      @watchlist = false
    end

    # Get the list of episodes.
    @episodes = @anime.episodes.order(:number)
    @episodes_watched = Hash.new(false)
    @episodes_viewed = []
    if user_signed_in?
      @episodes_viewed = current_user.episodes_viewed(@anime)
    end
    current_user.episodes_viewed(@anime).includes(:episode).each do |episodev|
      @episodes_watched[ episodev.episode.id ] = true
    end
    # Figure out the range of 4 episodes to show.
    if @episodes_viewed.length == 0
      @episodes = @episodes[0..3]
    else
      latest_watched = @episodes_viewed.map {|x| x.episode.number }.max
      if latest_watched+2 > @episodes.length-1
        @episodes = @episodes[-4..-1]
      else
        @episodes = @episodes[(latest_watched-1)..(latest_watched+2)]
      end
    end

    # Add to recently viewed.
    if @anime.sfw?
      session[:recently_viewed] ||= []
      session[:recently_viewed].delete( params[:id] )
      session[:recently_viewed].unshift( params[:id] )
      session[:recently_viewed].pop if session[:recently_viewed].length > 7
    end

    respond_to do |format|
      format.html { render :show }
    end
  end

  def index
    # Establish a base scope, with pagination enabled.
    @anime = Anime.sfw_filter(current_user).page(params[:page]).per(18)

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

    respond_to do |format|
      format.html { render :index }
    end
  end
end
