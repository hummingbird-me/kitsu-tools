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

FactoryGirl.define do
  factory :streaming_link do
    association :media, factory: :anime
    streamer
    url { Faker::Internet.url }
  end
end
