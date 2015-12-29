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

require 'rails_helper'

RSpec.describe Character, type: :model do
  it { should belong_to(:primary_media) }
  it { should have_many(:castings) }
  it { should validate_presence_of(:name) }
end
