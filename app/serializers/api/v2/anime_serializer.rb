module Api::V2
  class AnimeSerializer < Serializer
    title :anime

    field(:titles) do |a|
      {
        canonical: a.canonical_title,
        english: a.alt_title,
        romaji: a.title
      }
    end

    fields :slug, :synopsis, :started_airing_date, :finished_airing_date,
      :youtube_video_id, :age_rating, :episode_count, :episode_length,
      :show_type

    field(:poster_image) {|a| a.poster_image_thumb }
    field(:community_rating) {|a| a.bayesian_average }
    field(:genres) {|a| a.genres.map {|x| x.name } }

    has_many :gallery_images, serializer: GalleryImageSerializer
  end
end
