class AddEpisodesWatchedToWatchlist < ActiveRecord::Migration
  def change
    add_column :watchlists, :episodes_watched, :integer, :default => 0
  end
end
