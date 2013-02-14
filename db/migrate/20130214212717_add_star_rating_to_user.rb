class AddStarRatingToUser < ActiveRecord::Migration
  def change
    add_column :users, :star_rating, :boolean
  end
end
