class AnimeResource < BaseResource
  # This regex accepts a numerical range or single number
  # $1 = start, $2 = dot representing closed/open, $3 = end
  NUMBER = /(\d+(?:\.\d+)?)/
  NUMERIC_RANGE = %r{\A#{NUMBER}(?:(?:\.\.(\.)?)#{NUMBER})?\z}
  NUMERIC_QUERY = {
    valid: -> (value, _ctx) { NUMERIC_RANGE.match(value) },
    apply: -> (values, _ctx) {
      # We only accept the first value
      values.map do |value|
        matches = NUMERIC_RANGE.match(value)

        if matches[3] # Range
          Range.new(matches[1].to_f, matches[3].to_f, matches[2] == '.')
        else # Scalar
          matches[1]
        end
      end
    }
  }

  attributes :slug,
             # Images
             :poster_image, :cover_image, :cover_image_top_offset,
             # Titles
             :titles, :canonical_title, :abbreviated_titles,
             # Type, Dates, Synopsis, Trailer
             :show_type, :start_date, :end_date, :synopsis, :youtube_video_id,
             # Age Ratings
             :age_rating, :age_rating_guide,
             # Ratings
             :average_rating, :rating_frequencies,
             # Episodes
             :episode_count, :episode_length

  has_many :castings
  has_many :genres
  has_many :streaming_links
  has_many :installments

  filter :slug, apply: -> (records, value, _options) { records.by_slug(value) }

  # ElasticSearch hookup
  index MediaIndex::Anime
  query :season, valid: -> (value, _ctx) { Anime::SEASONS.include?(value) }
  query :year, NUMERIC_QUERY
  query :average_rating, NUMERIC_QUERY
  query :user_count, NUMERIC_QUERY
  query :episode_count, NUMERIC_QUERY
  query :genres,
    apply: -> (values, _ctx) {
      {match: {genres: {query: values.join(' '), operator: 'and'}}}
    }
  query :streamers,
    valid: -> (value, _ctx) { Streamer.find_by_name(value) }
  query :age_rating,
    valid: -> (value, _ctx) { Anime.age_ratings.keys.include?(value) }
  query :text, mode: :query,
    apply: -> (values, _ctx) {
      {
        function_score: {
          field_value_factor: {
            field: 'user_count',
            modifier: 'log1p'
          },
          query: {
            multi_match: {
              fields: %w[titles.* abbreviated_titles synopsis actors characters],
              query: values.join(','),
              fuzziness: 2,
              max_expansions: 15,
              prefix_length: 2
            }
          }
        }
      }
    }
end
