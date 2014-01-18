class AddNotNullConstraintToRewatchedTimes < ActiveRecord::Migration
  def up
    LibraryEntry.where(rewatched_times: nil).update_all rewatched_times: 0
    change_column :watchlists, :rewatched_times, :integer, null: false, default: 0
  end

  def down
    change_column :watchlists, :rewatched_times, :integer, default: 0
  end
end
