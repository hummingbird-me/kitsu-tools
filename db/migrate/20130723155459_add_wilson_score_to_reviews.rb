class AddWilsonScoreToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :wilson_score, :float
  end
end
