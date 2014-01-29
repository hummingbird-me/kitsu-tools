class RemoveMalAgeRatingFromAnime < ActiveRecord::Migration
  def change
    remove_column :anime, :mal_age_rating, :string
  end
end
