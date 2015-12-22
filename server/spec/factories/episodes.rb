# == Schema Information
#
# Table name: episodes
#
#  id                     :integer          not null, primary key
#  media_id               :integer          not null
#  number                 :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  season_number          :integer
#  synopsis               :text
#  thumbnail_file_name    :string(255)
#  thumbnail_content_type :string(255)
#  thumbnail_file_size    :integer
#  thumbnail_updated_at   :datetime
#  airdate                :date
#  length                 :integer
#  titles                 :hstore           default({}), not null
#  canonical_title        :string           default("ja_en"), not null
#  media_type             :string           not null
#

FactoryGirl.define do
  factory :episode do
    association :media, factory: :anime
    titles { {ja_en: Faker::Name.name} }
    canonical_title 'ja_en'
    synopsis { Faker::Lorem.paragraph }
    length { rand(20..60) }
    airdate { Faker::Date.between(20.years.ago, Date.today) }
    season_number 1
    sequence(:number)

    factory :drama_episode do
      association :media, factory: :drama
    end
  end
end
