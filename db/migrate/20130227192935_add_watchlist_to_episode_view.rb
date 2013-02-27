class AddWatchlistToEpisodeView < ActiveRecord::Migration
  def change
    add_column :episode_views, :watchlist_id, :integer
  end
end
