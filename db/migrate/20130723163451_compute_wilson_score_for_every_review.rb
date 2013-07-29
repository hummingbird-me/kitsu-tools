class ComputeWilsonScoreForEveryReview < ActiveRecord::Migration
  def up
    Review.find_each do |review|
      review.update_wilson_score!
    end
  end

  def down
  end
end
