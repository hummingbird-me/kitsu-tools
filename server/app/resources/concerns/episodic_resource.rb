module EpisodicResource
  extend ActiveSupport::Concern

  included do
    attributes :episode_count, :episode_length

    query :episode_count, MediaResource::NUMERIC_QUERY
    query :episode_length, MediaResource::NUMERIC_QUERY
  end
end
