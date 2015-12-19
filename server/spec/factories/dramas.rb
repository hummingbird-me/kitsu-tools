FactoryGirl.define do
  factory :drama do
    titles { {ja_en: Faker::Name.name} }
    canonical_title 'ja_en'
    average_rating { rand(1.0..10.0) / 2 }
    age_rating 'G'

    trait :nsfw do
      age_rting 'R18'
    end
  end
end
