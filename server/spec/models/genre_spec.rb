# rubocop:disable Metrics/LineLength
# == Schema Information
#
# Table name: genres
#
#  id          :integer          not null, primary key
#  description :text
#  name        :string(255)
#  slug        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# rubocop:enable Metrics/LineLength

require 'rails_helper'

RSpec.describe Genre, type: :model do
  it { should have_and_belong_to_many(:anime) }
  it { should have_and_belong_to_many(:manga) }
end
