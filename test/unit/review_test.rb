require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:anime)
  should validate_presence_of(:user)
  should validate_presence_of(:anime)
  should validate_presence_of(:content)
  should validate_presence_of(:rating)
  should validate_uniqueness_of(:user_id).scoped_to(:anime_id)

  def test_should_update_wilson_score
    # TODO
  end
end
