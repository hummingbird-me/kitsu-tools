# == Schema Information
#
# Table name: people
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  mal_id             :integer
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#

FactoryGirl.define do
  factory :person do
    name { Faker::Name.name }
  end
end
