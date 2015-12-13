FactoryGirl.define do
  factory :casting do
    association :media, factory: :anime
    character
  end
end
