class AddAgeRatingIndexToAnime < ActiveRecord::Migration
  def change
    add_index :anime, :age_rating
  end
end
