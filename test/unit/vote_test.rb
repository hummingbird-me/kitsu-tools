require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  test "tracks positive and total votes on model" do
    review = reviews(:one)
    initial_pos = review.positive_votes
    initial_tot = review.total_votes
    vote = Vote.create(user: users(:vikhyat), target: review)
    assert_equal initial_pos+1, review.reload.positive_votes
    assert_equal initial_tot+1, review.reload.total_votes
    vote.update_attributes positive: false
    assert_equal initial_pos, review.reload.positive_votes
    assert_equal initial_tot+1, review.reload.total_votes
    vote.update_attributes positive: true
    assert_equal initial_pos+1, review.reload.positive_votes
    assert_equal initial_tot+1, review.reload.total_votes
    vote2 = Vote.create(user: users(:josh), target: review, positive: false)
    assert_equal initial_pos+1, review.reload.positive_votes
    assert_equal initial_tot+2, review.reload.total_votes
    vote.destroy
    assert_equal initial_pos, review.reload.positive_votes
    assert_equal initial_tot+1, review.reload.total_votes
    vote2.destroy
    assert_equal initial_pos, review.reload.positive_votes
    assert_equal initial_tot, review.reload.total_votes
  end

  test "can get vote for user and model using `for`" do
    assert_nil Vote.for(users(:vikhyat), reviews(:one))
    Vote.create(user: users(:vikhyat), target: reviews(:one))
    assert_not_nil Vote.for(users(:vikhyat), reviews(:one))
  end
end
