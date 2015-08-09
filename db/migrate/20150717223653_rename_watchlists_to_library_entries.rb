class RenameWatchlistsToLibraryEntries < ActiveRecord::Migration
  def change
    rename_table :watchlists, :library_entries
    rename_column :stories, :watchlist_id, :library_entry_id
  end
end
