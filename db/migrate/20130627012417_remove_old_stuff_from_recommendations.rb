class RemoveOldStuffFromRecommendations < ActiveRecord::Migration
  def up
    remove_column :recommendations, :anime_id
    remove_column :recommendations, :score
    remove_column :recommendations, :category
  end

  def down
    add_column :recommendations, :category, :string
    add_column :recommendations, :score, :double
    add_column :recommendations, :anime_id, :integer
  end
end
