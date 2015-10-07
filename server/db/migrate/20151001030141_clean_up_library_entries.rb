class CleanUpLibraryEntries < ActiveRecord::Migration
  def change
    remove_column :library_entries, :last_watched
    remove_column :library_entries, :imported
    # Convert status to enum
    change_column :library_entries, :status, "integer USING (
      CASE status
      WHEN 'Currently Watching' THEN 1
      WHEN 'Plan to Watch' THEN 2
      WHEN 'Completed' THEN 3
      WHEN 'On Hold' THEN 4
      WHEN 'Dropped' THEN 5
      END
    )"
  end
end
