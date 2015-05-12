# == Schema Information
#
# Table name: apps
#
#  id         :integer          not null, primary key
#  creator_id :integer          not null
#  key        :string(255)      not null
#  secret     :string(255)      not null
#  name       :string(255)      not null
#

FactoryGirl.define do
  factory :app do
    name { Faker::App.name }
  end
end
