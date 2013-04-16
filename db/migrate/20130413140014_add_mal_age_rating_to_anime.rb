class AddMalAgeRatingToAnime < ActiveRecord::Migration
  def change
    add_column :anime, :mal_age_rating, :string
  end
end
