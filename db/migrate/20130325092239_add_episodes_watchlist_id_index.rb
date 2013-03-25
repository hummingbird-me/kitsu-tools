class AddEpisodesWatchlistIdIndex < ActiveRecord::Migration
  def change
    add_index :episodes_watchlists, :watchlist_id
  end
end
