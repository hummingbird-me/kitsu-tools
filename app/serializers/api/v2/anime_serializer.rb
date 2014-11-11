module Api::V2
  class AnimeSerializer < ObjectSerializer
    title :anime

    fields :id, :slug, :canonical_title, :synopsis, :started_airing_date,
      :finished_airing_date, :youtube_video_id, :age_rating, :episode_count,
      :episode_length

    field(:english_title) {|a| a.alt_title }
    field(:romaji_title) {|a| a.title }
    field(:poster_image) {|a| a.poster_image_thumb }
    field(:type) {|a| a.show_type }
    field(:community_rating) {|a| a.bayesian_average }
    field(:genres) {|a| a.genres.map {|x| x.name } }
    field(:screencaps) {|a| a.gallery_images.map {|x| x.image.url(:thumb) } }
  end
end
