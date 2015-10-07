class AnimeDeserializer < Deserializer
  model Anime
  key :id

  fields :poster_image, :cover_image, :cover_image_top_offset,
         # Titles
         :titles, :canonical_title, :abbreviated_titles,
         # Type, Dates, Synopsis
         :show_type, :start_date, :end_date, :synopsis,
         # Age Ratings
         :age_rating, :age_rating_guide,
         # Episodes
         :episode_count, :episode_length
  conditions cover_image: :data_uri?,
             poster_image: :data_uri?

  def self.data_uri?(str)
    str.starts_with?('data:') if str
  end
end
