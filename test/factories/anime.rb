FactoryGirl.define do

  factory :anime do
    title { Faker::Name.name }

    #TODO: Fix fucking factory association
    # after(:create) do |a|
    #   a.genres << create(:genre, anime: [a])
    # end
  end

end
