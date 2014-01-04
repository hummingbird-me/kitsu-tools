class MoveReviewEvaluationsToVotes < ActiveRecord::Migration
  def up
    Review.find_each do |review|
      review.evaluations.each do |ev|
        Vote.create(user: ev.source, target: review, positive: (ev.value == 1))
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
