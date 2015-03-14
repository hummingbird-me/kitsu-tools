FactoryGirl.define do
  factory :user do
    name { Faker::Internet.user_name(nil, ['_']) }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    avatar { Faker::Avatar.image }

    trait :with_stripe do
      billing_id { Stripe::Customer.create({
        email: email,
        card: StripeMock.create_test_helper.generate_card_token
      }).id }
      billing_method :stripe
    end
  end
end
