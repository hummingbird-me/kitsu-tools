# == Schema Information
#
# Table name: oauth_applications
#
#  id           :integer          not null, primary key
#  name         :string           not null
#  uid          :string           not null
#  secret       :string           not null
#  redirect_uri :text             not null
#  scopes       :string           default(""), not null
#  created_at   :datetime
#  updated_at   :datetime
#  owner_id     :integer
#  owner_type   :string
#

FactoryGirl.define do
  factory :oauth_application, class: ::Doorkeeper::Application do
    name { Faker::Internet.user_name }
    redirect_uri { Faker::Internet.url('example.com').sub('http', 'https') }
    association :owner, factory: :user
  end
end
