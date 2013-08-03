require 'wilson_score'

class AnimeController < ApplicationController
  include EpisodesHelper

  caches_action :show, if: lambda { not user_signed_in? }, expires_in: 1.hour
  
  def random
    anime = Anime.where("age_rating <> 'R18+'").where(show_type: ["TV", "OVA", "ONA", "Movie"]).order("RANDOM()").limit(1)[0]
    redirect_to anime
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
    
    @castings = Casting.where(anime_id: @anime.id, featured: true).sort_by {|x| x.order || 1000 }
    @languages = @castings.map {|x| x.role }.sort
    ["Japanese", "English"].reverse.each do |l|
      @languages.unshift l if @languages.include? l
    end
    @languages = @languages.uniq

    @gallery = @anime.gallery_images.limit(6)

    @reviews = @anime.reviews.includes(:user).order("wilson_score DESC").limit(4)

    if user_signed_in?
      @watchlist = Watchlist.where(anime_id: @anime.id, user_id: current_user.id).first
    else
      @watchlist = false
    end

    @franchise_anime = @anime.franchises.map {|x| x.anime }.flatten.uniq.sort_by {|x| x.started_airing_date || (Time.now + 100.years).to_date }
    
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

  def filter
    hide_cover_image
    @filter_years = ["Upcoming", "2010s", "2000s", "1990s", "1980s", "1970s", "Older"]

    if params[:g]
      @genres = Genre.where(slug: params[:g])
    else
      @genres = Genre.default_filterable(current_user)
    end
    
    if params[:y]
      @years = params[:y]
    else
      @years = @filter_years
    end
    
    if params[:sort]
      @sort = params[:sort]
    else
      @sort = "all"
    end
    
    @anime = Anime.accessible_by(current_ability).page(params[:page]).per(36)

    # Apply genre filter.
    if @genres.length > 10
      @anime = @anime.exclude_genres(Genre.all - @genres)
    else
      @anime = @anime.include_genres(@genres)
    end
    
    # Apply sort option.
    if @sort == "newest"
      @anime = @anime.order("started_airing_date DESC")
    elsif @sort == "oldest"
      @anime = @anime.order("started_airing_date")
    else
      @sort = "all"
      @anime = @anime.order("wilson_ci DESC")
    end
    
    # TODO Apply year filter.
    if @years.length != @filter_years.length
      filter_year_ranges = {
        "2010s" => Date.new(2010, 1, 1)..Date.new(2020, 1, 1),
        "2000s" => Date.new(2000, 1, 1)..Date.new(2010, 1, 1),
        "1990s" => Date.new(1990, 1, 1)..Date.new(2000, 1, 1),
        "1980s" => Date.new(1980, 1, 1)..Date.new(1990, 1, 1),
        "1970s" => Date.new(1970, 1, 1)..Date.new(1980, 1, 1),
        "Older" => Date.new(1800, 1, 1)..Date.new(1970, 1, 1)
      }
      arel = Anime.arel_table
      ranges = @years.map {|x| filter_year_ranges[x] }.compact
      query = ranges.inject(arel) do |sum, range|
        condition = arel[:started_airing_date].in(range).or(arel[:finished_airing_date].in(range))
        sum.class == Arel::Table ? condition : sum.or(condition)
      end
      if @years.include? "Upcoming"
        condition = arel[:status].eq("Not Yet Aired")
        if query.class == Arel::Table
          query = condition
        else
          query = query.or(arel[:status].eq("Not Yet Aired"))
        end
      end
      @anime = @anime.where(query)
    end

    # Load library entries for the user.
    # NOTE When the seen/unseen filter is added use a join or something.
    @library_entries = {}
    if user_signed_in?
      @library_entries = Watchlist.where(anime_id: @anime.map {|x| x.id}, 
                                         user_id: current_user.id)
                                  .index_by(&:anime_id)
    end
    
    render :explore_filter
  end

  def index
    hide_cover_image
    @filter_years = ["Upcoming", "2010s", "2000s", "1990s", "1980s", "1970s", "Older"]

    @trending_anime = TrendingAnime.get(6).map {|x| Anime.find(x) }
    @recent_reviews = Review.order('created_at DESC').limit(12).includes(:anime)
    trending_review_candidates = Review.where("created_at >= ?", 30.days.ago).order("wilson_score DESC").limit(30)
    @trending_reviews = []
    trending_review_candidates.each do |candidate|
      unless @trending_reviews.any? {|r| r.user_id == candidate.user_id }
        @trending_reviews.push candidate
      end
      break if @trending_reviews.length == 6
    end
    
    @forum_topics = Forem::Forum.find("anime-manga").topics.by_most_recent_post.joins(:user).where('NOT users.ninja_banned').limit(10)

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
