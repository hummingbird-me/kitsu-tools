module Api::V2
  class AnimeSerializer < Serializer
    title :anime

    field(:titles) do |a|
      {
        canonical: a.canonical_title,
        english: a.alt_title,
        romaji: a.title,
        japanese: a.jp_title
      }
    end

    fields :slug, :synopsis, :started_airing_date, :finished_airing_date,
      :youtube_video_id, :age_rating, :episode_count, :episode_length,
      :show_type

    field(:poster_image) {|a| a.poster_image.url(:large) }
    field(:cover_image) {|a| a.cover_image.url(:thumb) }
    field(:community_rating) {|a| a.bayesian_rating }
    field(:genres) {|a| a.genres.map {|x| x.name } }
    field(:producers) {|a| a.producers.map {|x| x.name } }
    field(:bayesian_rating) {|a| a.bayesian_rating }

    has_many :gallery_images, serializer: GalleryImageSerializer
    has_many :episodes, serializer: EpisodeSerializer
  end
end
