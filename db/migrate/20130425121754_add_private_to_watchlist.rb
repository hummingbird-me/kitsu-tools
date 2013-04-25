class AddPrivateToWatchlist < ActiveRecord::Migration
  def change
    add_column :watchlists, :private, :boolean, default: false
  end
end
