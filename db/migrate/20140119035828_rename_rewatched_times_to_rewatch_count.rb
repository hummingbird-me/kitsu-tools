class RenameRewatchedTimesToRewatchCount < ActiveRecord::Migration
  def change
    rename_column :watchlists, :rewatched_times, :rewatch_count
  end
end
