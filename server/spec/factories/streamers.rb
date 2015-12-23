# == Schema Information
#
# Table name: streamers
#
#  id                :integer          not null, primary key
#  site_name         :string(255)      not null
#  logo_file_name    :string
#  logo_content_type :string
#  logo_file_size    :integer
#  logo_updated_at   :datetime
#

FactoryGirl.define do
  factory :streamer do
    site_name { Faker::Company.name }
    logo { Faker::Company.logo }
  end
end
