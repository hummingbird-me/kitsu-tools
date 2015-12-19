# == Schema Information
#
# Table name: characters
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  description        :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  mal_id             :integer
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  slug               :string(255)
#  primary_media_id   :integer
#  primary_media_type :string
#

FactoryGirl.define do
  factory :character do
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
  end
end
