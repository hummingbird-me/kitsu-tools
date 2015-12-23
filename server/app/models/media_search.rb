class MediaSearch
  SEASON_RANGES = {
    winter: -> (year) { Date.new(year-1, 12)...Date.new(year, 3) },
    spring: -> (year) { Date.new(year, 3)...Date.new(year, 6) },
    summer: -> (year) { Date.new(year, 6)...Date.new(year, 9) },
    fall:   -> (year) { Date.new(year, 9)...Date.new(year, 12) }
  }

  def initialize
    @scope = AnimeIndex::Anime
  end

  # Mutate the scope with a text query
  #
  # @param [String] terms the string to query with
  # @return [Self]
  def query!(terms)
    @scope = @scope.query({
      function_score: {
        field_value_factor: {
          field: 'user_count',
          modifier: 'log1p'
        },
        query: {
          bool: {
            should: [
              { term: { characters: terms } },
              { term: { actors: terms } },
              { term: { 'titles.*' => terms } },
              {
                multi_match: {
                  fields: %w[titles.* abbreviated_titles synopsis actors characters],
                  query: terms,
                  fuzziness: 2,
                  max_expansions: 10,
                  prefix_length: 2
                }
              }
            ],
            minimum_should_match: 1
          }
        }
      }
    })
    self
  end

  # Apply a fulltext query to the media
  #
  # @param [String] terms the string to query with
  # @return [MediaSearch] a modified search with the query applied
  def query(terms)
    dup.query!(terms)
  end

  # Mutate the search to apply a genre filter
  #
  # @param [String, Array<String>, Array<Fixnum>] genres the genres to filter with
  # @return [Self]
  def with_genres!(genres)
    if genres.is_a? Array
      genres = genres.map { |g| g.is_a?(Fixnum) ? Genre.find(g).name : g }
      genres = genres.join(' ')
    end
    filter_match_or!(:genres, genres)
  end

  # Apply a genre filter to a search
  #
  # @param [String, Array<String>] the genres to filter with
  # @return [MediaSearch] genres a modified search with the filter applied
  def with_genres(genres)
    dup.with_genres!(genres)
  end

  # Mutate the search to apply a release-date range filter
  #
  # @param [Range<Date>, Fixnum] range_or_year the date range or year to filter to
  # @param [Symbol, nil] season the season to filter to (used with year)
  # @return [Self]
  def released_in!(range_or_year, season = nil)
    if range_or_year.is_a? Fixnum
      if season
        range_or_year = SEASON_RANGES[season].call(range_or_year)
      else
        range_or_year = Date.new(range_or_year)...Date.new(range_or_year+1)
      end
    end
    filter_range!(:start_date, range_or_year)
  end

  # Apply a release-date range filter to a search
  #
  # @param [Range<Date>, Fixnum] range_or_year the date range or year to filter to
  # @param [Symbol, nil] season the season to filter to (used with year)
  # @return [MediaSearch] a modified search with the filter applied
  def released_in(range_or_year, season = nil)
    dup.released_in!(range_or_year, season)
  end

  # Mutate the search to apply a rating range filter
  #
  # @param [Range<Float>] range the rating range to filter with
  # @return [Self]
  def rated!(range)
    filter_range!(:average_rating, range)
  end

  # Apply a rating range filter to a search
  #
  # @param [Range<Float>] range the rating range to filter with
  # @return [MediaSearch] a modified search with the filter applied
  def rated(range)
    dup.rated!(range)
  end

  # Mutate the search to apply an age rating filter
  #
  # @param [Array<String>, String] age_rating the age rating(s) to filter to
  # @return [Self]
  def age_rating!(rating)
    rating = rating.join(' ') if rating.is_a? Array
    filter_match_or!(:age_rating, rating)
  end

  # Apply an age rating filter to a search
  #
  # @param [Array<String>, String] age_rating the age rating(s) to filter to
  # @return [Self]
  def age_rating(rating)
    dup.age_rating!(rating)
  end

  # Return index
  def index
    @scope
  end

  private
  # Add a `match` filter in AND mode
  def filter_match_and!(field, values)
    @scope = @scope.filter(match: {field => {query: values, operator: 'and'}})
    self
  end

  # Add a match` filter in OR mode
  def filter_match_or!(field, values)
    @scope = @scope.filter(match: {field => {query: values, operator: 'or'}})
    self
  end

  # Add a `range` filter
  def filter_range!(field, range)
    @scope = @scope.filter(range: {field => {gte: range.min, lte: range.max}})
    self
  end
end
