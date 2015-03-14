FactoryGirl.define do
  factory :user do
    name { Faker::Internet.user_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    avatar { Faker::Avatar.image }

    trait :with_stripe do
      billing_id { Stripe::Customer.create({
        email: email,
        card: StripeMock.create_test_helper.generate_card_token
      }).id }
    end
  end
end
