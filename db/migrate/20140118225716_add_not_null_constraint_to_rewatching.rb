class AddNotNullConstraintToRewatching < ActiveRecord::Migration
  def up
    LibraryEntry.where(rewatching: nil).update_all rewatching: false
    change_column :watchlists, :rewatching, :boolean, null: false, default: false
  end

  def down
    change_column :watchlists, :rewatching, :boolean, default: false
  end
end
