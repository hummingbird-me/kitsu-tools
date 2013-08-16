class AddRewatchingToWatchlists < ActiveRecord::Migration
  def change
    add_column :watchlists, :rewatching, :boolean
  end
end
