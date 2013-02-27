class AddLastWatchedToWatchlist < ActiveRecord::Migration
  def change
    add_column :watchlists, :last_watched, :datetime
  end
end
