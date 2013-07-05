class RemoveWatchlistHashFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :watchlist_hash
  end

  def down
    add_column :users, :watchlist_hash, :string
  end
end
