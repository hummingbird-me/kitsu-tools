# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: characters
#
#  id                 :integer          not null, primary key
#  description        :text
#  image_content_type :string(255)
#  image_file_name    :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  name               :string(255)
#  primary_media_type :string
#  slug               :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  mal_id             :integer          indexed, indexed
#  primary_media_id   :integer
#
# Indexes
#
#  character_mal_id            (mal_id) UNIQUE
#  index_characters_on_mal_id  (mal_id) UNIQUE
#
# rubocop:enable Metrics/LineLength

FactoryGirl.define do
  factory :character do
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
  end
end
