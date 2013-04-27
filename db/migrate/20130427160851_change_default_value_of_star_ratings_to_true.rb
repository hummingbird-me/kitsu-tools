class ChangeDefaultValueOfStarRatingsToTrue < ActiveRecord::Migration
  def change
    change_column_default :users, :star_rating, false
  end
end
