class AddAgeRatingTooltipToAnime < ActiveRecord::Migration
  def change
    add_column :anime, :age_rating_tooltip, :string
  end
end
