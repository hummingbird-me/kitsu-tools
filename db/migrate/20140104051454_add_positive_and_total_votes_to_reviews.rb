class AddPositiveAndTotalVotesToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :positive_votes, :integer, default: 0
    add_column :reviews, :total_votes, :integer, default: 0
  end
end
