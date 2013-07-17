class AnimeController < ApplicationController
  include EpisodesHelper
  
  def ci_lower_bound(pos, n)
    if n == 0
      return 0
    end
    z = 1.96
    phat = 1.0*pos/n
    (phat + z*z/(2*n) - z * Math.sqrt((phat*(1-phat)+z*z/(4*n))/n))/(1+z*z/n)
  end
  
  def show
    @anime = Anime.find(params[:id])
    # Redirect the user to the canonical URL if they got here from an old or
    # numeric ID.
    if request.path != anime_path(@anime)
      return redirect_to @anime, :status => :moved_permanently
    end
    
    @genres = @anime.genres
    @producers = @anime.producers
    @quotes = Quote.includes(:user).find_with_reputation(:votes, :all, {:conditions => ["anime_id = ?", @anime.id], :order => "votes DESC", :limit => 4})
    
    @castings = Casting.where(anime_id: @anime.id, featured: true)
    @languages = @castings.map {|x| x.role }.sort
    ["Japanese", "English"].reverse.each do |l|
      @languages.unshift l if @languages.include? l
    end
    @languages = @languages.uniq

    @gallery = @anime.gallery_images.limit(6)

    @reviews = Review.includes(:user).find_with_reputation(:votes, :all, {:conditions => ["anime_id = ?", @anime.id]}).sort_by do |review|
      -ci_lower_bound(review.votes.to_i, review.evaluations.length)
    end
    @reviews = @reviews[0...4] if @reviews.length > 4

    if user_signed_in?
      @watchlist = Watchlist.where(anime_id: @anime.id, user_id: current_user.id).first
    else
      @watchlist = false
    end

    @franchise_anime = @anime.franchises.map {|x| x.anime }.flatten.uniq.sort_by {|x| x.started_airing_date }
    
    @similar = @anime.similar(2, exclude: @franchise_anime)

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

  def update
    @anime = Anime.find(params[:id])
    authorize! :update, @anime
    @anime.episode_count = params[:anime][:episode_count]
    @anime.episode_length = params[:anime][:episode_length]
    @anime.thetvdb_series_id = params[:anime][:thetvdb_series_id]
    @anime.thetvdb_season_id = params[:anime][:thetvdb_season_id]
    @anime.mal_id = params[:anime][:mal_id]
    @anime.english_canonical = params[:anime][:english_canonical]
    @anime.save
    redirect_to @anime
  end
  
  def get_episodes_from_thetvdb
    @anime = Anime.find(params[:anime_id])
    authorize! :update, @anime
    TheTvdb.save_episode_data(@anime)
    redirect_to @anime
  end
  
  def get_metadata_from_mal
    @anime = Anime.find(params[:anime_id])
    authorize! :update, @anime
    @anime.get_metadata_from_mal
    redirect_to @anime
  end

  def index
    hide_cover_image

    if params[:filter]
      render :explore_filter
    else
      @trending_anime = TrendingAnime.get(6).map {|x| Anime.find(x) }
      @recent_reviews = Review.order('created_at DESC').limit(12).includes(:anime)
    end

    return
    ### OLD EXPLORE PAGE CODE BELOW

    # Establish a base scope.
    @anime = Anime.accessible_by(current_ability)

    # Get a list of all genres.
    @all_genres = Genre.default_filterable(current_user)

    # Filter by genre if needed.
    if params[:genres] and params[:genres].length > 0
      @all_genre_slugs = @all_genres.map {|x| x.slug }
      @slugs_to_filter = params[:genres]
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
    
    # Order by Wilson CI lower bound, except for the recommendations page.
    unless @filter == "recommended"
      @anime = @anime.order('anime.wilson_ci DESC')
    end

    unless @filter == "unfinished"
      @anime = @anime.page(params[:page]).per(18)
    end

    if @filter == "unseen"

      # The user needs to be signed in for this one.
      authenticate_user!

      # Get anime which the user doesn't have on their watchlist.
      @anime = @anime.where('anime.id NOT IN (?)', @watchlist.keys)
      
    elsif @filter == "unfinished"

      @anime = @anime.where('anime.id IN (?)', @watchlist.keys)
        .reject {|x| ["Completed", "Dropped"].include? @watchlist[x.id].status }
        
      @anime = Kaminari.paginate_array(@anime).page(params[:page]).per(18)

    elsif @filter == "recommended"

      redirect_to recommendations_path
      return

    else
      # We don't have to do any filtering.
    end
    
    @collection = @anime.map {|x| [x, @watchlist[x.id]] }

    respond_to do |format|
      format.html { render :index }
    end
  end
end
