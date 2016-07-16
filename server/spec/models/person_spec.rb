# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: people
#
#  id                 :integer          not null, primary key
#  image_content_type :string(255)
#  image_file_name    :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  name               :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  mal_id             :integer          indexed, indexed
#
# Indexes
#
#  index_people_on_mal_id  (mal_id) UNIQUE
#  person_mal_id           (mal_id) UNIQUE
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe Person, type: :model do
  it { should have_many(:castings) }
  it { should validate_presence_of(:name) }
end
