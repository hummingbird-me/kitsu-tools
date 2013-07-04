class WatchlistDoesntNeedIndexing < ActiveRecord::Migration
  def change
    remove_index :watchlists, :created_at
    remove_index :watchlists, :last_watched
  end
end
