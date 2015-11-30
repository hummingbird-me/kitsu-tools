# == Schema Information
#
# Table name: genres
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  slug        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text
#

FactoryGirl.define do
  factory :genre do
    name { Faker::Book.genre }
  end
end
