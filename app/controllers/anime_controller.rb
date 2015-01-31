require 'wilson_score'

class AnimeController < ApplicationController
  include MicrodataHelper
  def random
    anime = Anime.where("age_rating <> 'R18+'").where(show_type: ["TV", "OVA", "ONA", "Movie"]).order("RANDOM()").limit(1)[0]
    redirect_to anime
  end

  def show
    @anime = Anime.includes(:genres).find(params[:id])

    respond_to do |format|
      format.html do
        # Redirect to canonical URL if this isn't it.
        if request.path != anime_path(@anime)
          return redirect_to @anime, status: :moved_permanently
        end

        preload_to_ember! @anime, serializer: FullAnimeSerializer, root: "full_anime"
        render layout: 'redesign'
      end
      format.json do
        render json: @anime
      end
    end
  end

  def upcoming
    hide_cover_image

    season_months = Anime::SEASON_MONTHS
    @seasons = season_months.keys
    @seasons.rotate! until season_months[@seasons[0]].include? Time.now.month
    current_season = @seasons[0]
    @season = [@seasons, 'tba'].flatten.include?(params[:season]) ? params[:season] : current_season

    @season_years = {}
    if Time.now.month == 12
      # If this is December, we are in the Winter season and want to show stuff
      # for the upcoming year.
      @seasons.each {|s| @season_years[s] = Time.now.year + 1 }
    else
      # Otherwise, at first set all of the seasons to the current year.
      @seasons.each {|s| @season_years[s] = Time.now.year }
      @seasons.each do |season|
        if Time.now.month > season_months[season][-1]
          @season_years[season] += 1
        end
      end
    end

    @anime = Anime.accessible_by(current_ability)

    if @season == 'tba'
      @anime = @anime.in_season('tba')
    else
      @anime = @anime.in_season(@season, @season_years[@season])
    end

    @anime = @anime.order_by_rating.group_by {|anime| anime.show_type }
  end

  def filter
    if params[:new_filter].nil?
      filter_old()
    else
      filter_new()
    end
  end

  def filter_old
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

    @anime = Anime.accessible_by(current_ability).references(:genres).page(params[:page]).per(36)

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
    elsif @sort == "popular"
      @anime = @anime.order("user_count DESC NULLS LAST")
    else
      @sort = "rating"
      @anime = @anime.order_by_rating
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
        condition = arel[:started_airing_date].gt(Time.now.to_date).or(arel[:started_airing_date].eq(nil))
        if query.class == Arel::Table
          query = condition
        else
          query = query.or(condition)
        end
      end
      @anime = @anime.where(query)
    end

    # Load library entries for the user.
    # NOTE When the seen/unseen filter is added use a join or something.
    @library_entries = {}
    if user_signed_in?
      @library_entries = LibraryEntry.where(anime_id: @anime.map {|x| x.id},
                                            user_id: current_user.id)
                                     .index_by(&:anime_id)
    end

    render :explore_filter
  end

  def filter_new
    @filter_years = ["Upcoming", "2010s", "2000s", "1990s", "1980s", "1970s", "Older"]

    respond_to do |format|
      format.html do
        preload_to_ember! Genre.all, each_serializer: GenreSerializer

        render_ember
      end

      format.json do

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

        @anime = Anime.accessible_by(current_ability).references(:genres).page(params[:page]).per(36)

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
        elsif @sort == "popular"
          @anime = @anime.order("user_count DESC NULLS LAST")
        else
          @sort = "rating"
          @anime = @anime.order_by_rating
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
            condition = arel[:started_airing_date].gt(Time.now.to_date).or(arel[:started_airing_date].eq(nil))
            if query.class == Arel::Table
              query = condition
            else
              query = query.or(condition)
            end
          end
          @anime = @anime.where(query)
        end

        # Load library entries for the user.
        # NOTE When the seen/unseen filter is added use a join or something.
        @library_entries = {}
        if user_signed_in?
          @library_entries = LibraryEntry.where(anime_id: @anime.map {|x| x.id},
                                                user_id: current_user.id)
                                         .index_by(&:anime_id)
        end

        render json: @anime

      end
    end
  end

  def index
    respond_to do |format|
      format.html do
        hide_cover_image
        @filter_years = ["Upcoming", "2010s", "2000s", "1990s", "1980s", "1970s", "Older"]

        @trending_anime = TrendingAnime.list(6)
        @recent_reviews = Review.order('created_at DESC').limit(12).includes(:anime)
        @trending_reviews = Review.trending(start: 30.days.ago, limit: 6).includes(:anime, :user)
      end

      format.json do
        anime = Anime
        anime = Anime.where(slug: params[:ids]) if params[:ids]
        anime = Anime.order(params[:sort_by] + (params[:sort_reverse].nil? ? "" : " DESC NULLS LAST")) if params[:sort_by] && params[:sort_by].in?(%w[bayesian_average user_count])
        render json: anime.sfw_filter(current_user).includes(:genres).page(params[:page]).per(40)
      end
    end
  end
end
