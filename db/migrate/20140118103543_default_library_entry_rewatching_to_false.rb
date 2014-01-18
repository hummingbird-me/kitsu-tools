class DefaultLibraryEntryRewatchingToFalse < ActiveRecord::Migration
  def up
    change_column :watchlists, :rewatching, :boolean, default: false
    LibraryEntry.where(rewatching: nil).update_all rewatching: false
  end

  def down
    change_column :watchlists, :rewatching, :boolean, default: nil
  end
end
