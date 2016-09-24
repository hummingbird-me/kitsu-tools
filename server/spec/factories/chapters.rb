# == Schema Information
#
# Table name: Chapters
#
#  id                   :integer          not noll, primary key
#  manga_id             :integer          not noll, foreign key
#  titles               :hstore           default({}), not null
#  canonical_title      :string           default("en_jp"), not null
#  number               :integer          not null
#  volume               :integer
#  length               :integer
#  synopsis             :text
#  published            :date
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

FactoryGirl.define do
  factory :chapter do
    association :manga, factory: :manga
    titles { { en_jp: Faker::Name.name } }
    canonical_title 'en_jp'
    sequence(:number)
    length { rand(20..60) }
    volume { rand(1..10) }
    synopsis { Faker::Lorem.paragraph }
    published { Faker::Date.between(20.years.ago, Date.today) }
  end
end
