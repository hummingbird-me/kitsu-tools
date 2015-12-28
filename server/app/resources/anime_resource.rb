class AnimeResource < BaseResource
  # This regex accepts a numerical range
  # $1 = start, $2 = dot representing closed/open, $3 = end
  NUMBER_RANGE = /\A(\d+(?:\.\d*)?)(?:\.\.(\.)?)(\d+(?:\.\d*)?)\z/
  NUMBER = /\A\d+(?:\.\d\*)?\z/

  attributes :slug,
             # Images
             :poster_image, :cover_image, :cover_image_top_offset,
             # Titles
             :titles, :canonical_title, :abbreviated_titles,
             # Type, Genres, Dates, Synopsis
             :show_type, :genres, :start_date, :end_date, :synopsis,
             # Age Ratings
             :age_rating, :age_rating_guide,
             # Ratings
             :average_rating, :rating_frequencies,
             # Episodes
             :episode_count, :episode_length

  def genres
    @model.genres.map(&:name).sort
  end

  filter :slug, apply: -> (records, value, _options) { records.by_slug(value) }

  # ElasticSearch hookup
  index AnimeIndex::Anime
  query :season, verify: -> (value, _ctx) { value.in? Anime::SEASONS }
  query :year, verify: -> (value, _ctx) { NUMBER.match(value) }
  query :average_rating,
    verify: -> (value, _ctx) { NUMBER_RANGE.match(value) || NUMBER.match(value) },
    apply: -> (value, _ctx) {
      if NUMBER_RANGE.match(value)
        Range.new($1.to_f, $3.to_f, $2 == '.')
      elsif NUMBER.match(value)
        value.to_f
      end
    }
  query :genres, apply: -> (value, _ctx) {
    # Must match all genres
    {match: {genres: {query: value.split(',').join(' '), operator: 'and'}}}
  }
  query :age_rating, apply: -> (value, _ctx) { value.split(',').join(' ') }
  query :text, mode: :query, apply: -> (value, _ctx) {
    {
      function_score: {
        field_value_factor: {
          field: 'user_count',
          modifier: 'log1p'
        },
        query: {
          multi_match: {
            fields: %w[titles.* abbreviated_titles synopsis actors characters],
            query: value,
            fuzziness: 2,
            max_expansions: 15,
            prefix_length: 2
          }
        }
      }
    }
  }
end
