class RemovePositiveFromWatchlist < ActiveRecord::Migration
  def up
    remove_column :watchlists, :positive
  end

  def down
    add_column :watchlists, :positive, :boolean
  end
end
