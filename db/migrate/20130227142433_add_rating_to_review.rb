class AddRatingToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :rating, :integer
    execute "UPDATE reviews SET rating = -2;"
    execute "UPDATE reviews SET rating = 2 WHERE positive;"
  end
end
