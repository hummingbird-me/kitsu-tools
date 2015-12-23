class AnimeResource < BaseResource
  attributes :slug,
             # Images
             :poster_image, :cover_image, :cover_image_top_offset,
             # Titles
             :titles, :canonical_title, :abbreviated_titles,
             # Type, Dates, Synopsis
             :show_type, :start_date, :end_date, :synopsis,
             # Age Ratings
             :age_rating, :age_rating_guide,
             # Ratings
             :average_rating, :rating_frequencies,
             # Episodes
             :episode_count, :episode_length

  filter :slug, apply: -> (records, value, _options) { records.by_slug(value) }
end
