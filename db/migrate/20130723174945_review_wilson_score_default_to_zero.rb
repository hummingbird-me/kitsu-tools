class ReviewWilsonScoreDefaultToZero < ActiveRecord::Migration
  def up
    change_column :reviews, :wilson_score, :float, default: 0.0
  end

  def down
  end
end
