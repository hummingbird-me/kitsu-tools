class AddFavRankToFavorites < ActiveRecord::Migration
  def change
    add_column :favorites, :fav_rank, :integer, default: 9999 
    add_index :favorites, :fav_rank
  end
end
