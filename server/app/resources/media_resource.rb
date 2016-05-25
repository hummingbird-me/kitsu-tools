class MediaResource < BaseResource
  attributes :slug,
             # Images
             :poster_image, :cover_image, :cover_image_top_offset,
             # Titles
             :titles, :canonical_title, :abbreviated_titles,
             # Ratings
             :average_rating, :rating_frequencies,
             # Dates
             :start_date, :end_date

  has_many :genres
  has_many :castings
  has_many :installments
end
