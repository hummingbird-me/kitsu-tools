class SortOutWatchlistIndexes < ActiveRecord::Migration
  def change
    remove_index :watchlists, column: [:anime_id, :rating]
    add_index :watchlists, [:user_id]
    add_index :watchlists, [:user_id, :status]
  end
end
