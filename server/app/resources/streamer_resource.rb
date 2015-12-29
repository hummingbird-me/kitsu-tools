class StreamerResource < BaseResource
  attributes :site_name, :logo

  has_many :streaming_links
end
