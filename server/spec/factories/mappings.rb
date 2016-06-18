FactoryGirl.define do
  factory :mapping do
    association :media, factory: :anime
    external_site 'myanimelist'
    external_id { rand(0..50000) }
  end
end
