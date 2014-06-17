# == Schema Information
#
# Table name: reviews
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  anime_id         :integer
#  content          :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  rating           :integer
#  source           :string(255)
#  rating_story     :integer
#  rating_animation :integer
#  rating_sound     :integer
#  rating_character :integer
#  rating_enjoyment :integer
#  summary          :string(255)
#  wilson_score     :float            default(0.0)
#  positive_votes   :integer          default(0)
#  total_votes      :integer          default(0)
#

require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:anime)
  should validate_presence_of(:user)
  should validate_presence_of(:anime)
  should validate_presence_of(:content)
  should validate_presence_of(:rating)
  should validate_presence_of(:rating_animation)
  should validate_presence_of(:rating_sound)
  should validate_presence_of(:rating_character)
  should validate_presence_of(:rating_enjoyment)
  should validate_presence_of(:rating_story)
  should validate_uniqueness_of(:user_id).scoped_to(:anime_id)

  def test_should_update_wilson_score
    # TODO
  end
end
