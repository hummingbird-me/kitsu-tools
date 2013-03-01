class AddEpisodesWatchlistsJoin < ActiveRecord::Migration
  def change
    create_table :episodes_watchlists, :id => false do |t|
      t.references :episode, :null => false
      t.references :watchlist, :null => false
    end
    add_index(:episodes_watchlists, [:episode_id, :watchlist_id], :unique => true)
  end
end
