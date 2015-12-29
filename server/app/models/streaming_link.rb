# == Schema Information
#
# Table name: streaming_links
#
#  id          :integer          not null, primary key
#  media_id    :integer          not null
#  media_type  :string           not null
#  streamer_id :integer          not null
#  url         :string           not null
#  subs        :string           default(["en"]), not null, is an Array
#  dubs        :string           default(["ja"]), not null, is an Array
#

class StreamingLink < ActiveRecord::Base
  belongs_to :media, polymorphic: true, touch: true
  belongs_to :streamer

  validates :media, :streamer, :url, :subs, :dubs, presence: true

  scope :dubbed, -> (langs) { where('dubs @> ARRAY[?]::varchar[]', langs) }
  scope :subbed, -> (langs) { where('subs @> ARRAY[?]::varchar[]', langs) }
end
