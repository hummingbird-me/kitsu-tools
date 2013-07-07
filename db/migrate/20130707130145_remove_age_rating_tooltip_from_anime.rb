class RemoveAgeRatingTooltipFromAnime < ActiveRecord::Migration
  def up
    remove_column :anime, :age_rating_tooltip
  end

  def down
    add_column :anime, :age_rating_tooltip, :string
  end
end
