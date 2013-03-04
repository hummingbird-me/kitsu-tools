class AddImportedToWatchlist < ActiveRecord::Migration
  def change
    add_column :watchlists, :imported, :boolean
  end
end
