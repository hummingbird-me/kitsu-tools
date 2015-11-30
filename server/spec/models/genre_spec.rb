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

require 'rails_helper'

RSpec.describe Genre, type: :model do
  it { should have_and_belong_to_many(:anime) }
  it { should have_and_belong_to_many(:manga) }
end
