class AddNotNullConstraintToLibraryEntries < ActiveRecord::Migration
  def up
    LibraryEntry.where(episodes_watched: nil).update_all episodes_watched: 0
    change_column :watchlists, :episodes_watched, :integer, null: false, default: 0
  end

  def down
    change_column :watchlists, :episodes_watched, :integer, default: 0
  end
end
