class StreamingLinkResource < BaseResource
  attributes :url, :subs, :dubs

  has_one :streamer
  has_one :media, polymorphic: true
end
