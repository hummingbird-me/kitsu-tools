class DramaResource < MediaResource
  include EpisodicResource

  attributes :show_type, :youtube_video_id

  # ElasticSearch hookup
  index MediaIndex::Drama
end
