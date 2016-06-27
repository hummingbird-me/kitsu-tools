class AnimeResource < MediaResource
  include EpisodicResource

  attributes :show_type, :youtube_video_id, :age_rating, :age_rating_guide
  has_many :streaming_links

  # ElasticSearch hookup
  index MediaIndex::Anime
  query :season, valid: -> (value, _ctx) { Anime::SEASONS.include?(value) }
  query :streamers, valid: -> (value, _ctx) { Streamer.find_by_name(value) }
  query :age_rating,
    valid: -> (value, _ctx) { Anime.age_ratings.keys.include?(value) }
end
