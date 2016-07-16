# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: episodes
#
#  id                     :integer          not null, primary key
#  airdate                :date
#  canonical_title        :string           default("en_jp"), not null
#  length                 :integer
#  media_type             :string           not null, indexed => [media_id]
#  number                 :integer
#  season_number          :integer
#  synopsis               :text
#  thumbnail_content_type :string(255)
#  thumbnail_file_name    :string(255)
#  thumbnail_file_size    :integer
#  thumbnail_updated_at   :datetime
#  titles                 :hstore           default({}), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  media_id               :integer          not null, indexed => [media_type]
#
# Indexes
#
#  index_episodes_on_media_type_and_media_id  (media_type,media_id)
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :episode do
    association :media, factory: :anime
    titles { { en_jp: Faker::Name.name } }
    canonical_title 'en_jp'
    synopsis { Faker::Lorem.paragraph(4) }
    length { rand(20..60) }
    airdate { Faker::Date.between(20.years.ago, Date.today) }
    season_number 1
    sequence(:number)

    factory :drama_episode do
      association :media, factory: :drama
    end
  end
end
