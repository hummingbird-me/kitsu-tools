class AddAgeRatingGuideToAnime < ActiveRecord::Migration
  def change
    add_column :anime, :age_rating_guide, :string
  end
end
