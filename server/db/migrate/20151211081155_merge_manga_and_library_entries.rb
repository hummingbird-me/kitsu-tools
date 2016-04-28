class MergeMangaAndLibraryEntries < ActiveRecord::Migration
  def change
    # Anime --> Media
    remove_index :library_entries, [:user_id, :anime_id]
    rename_column :library_entries, :anime_id, :media_id
    add_column :library_entries, :media_type, :string
    change_column_null :library_entries, :media_type, false, 'Anime'
    add_index :library_entries, [:user_id, :media_type, :media_id], unique: true

    # Episodes --> Progress
    rename_column :library_entries, :episodes_watched, :progress

    # Rewatch --> Reconsume
    rename_column :library_entries, :rewatching, :reconsuming
    rename_column :library_entries, :rewatch_count, :reconsume_count

    # Add volumes column
    add_column :library_entries, :volumes_owned, :integer, default: 0, null: false

    # General cleanup
    change_column_null :library_entries, :private, false, false
    change_column_null :library_entries, :status, false
    change_column_null :library_entries, :media_id, false
    change_column_null :library_entries, :media_type, false
    change_column_null :library_entries, :user_id, false

    # Convert manga to integer status
    change_column :manga_library_entries, :status, "integer USING (
      CASE status
      WHEN 'Currently Reading' THEN 1
      WHEN 'Plan to Read' THEN 2
      WHEN 'Completed' THEN 3
      WHEN 'On Hold' THEN 4
      WHEN 'Dropped' THEN 5
      ELSE 1
      END
    )".squish

    # Remove duplicates on (user_id, manga_id), picking the higher updated_at
    # The new destination table has a uniqueness constraint to prevent this in
    # future, but we still have some dupes we need to fix.
    execute <<-SQL.squish
      DELETE FROM manga_library_entries
      WHERE id IN (
        SELECT id FROM (
          SELECT id, ROW_NUMBER()
          OVER (partition BY user_id, manga_id ORDER BY updated_at DESC) AS rnum
          FROM manga_library_entries
        ) t
        WHERE t.rnum > 1
      )
    SQL

    # Now we shuffle manga library entries into here!
    execute <<-SQL.squish
      INSERT INTO library_entries (
        user_id, media_id, media_type, progress, status, volumes_owned,
        reconsume_count, reconsuming, private, rating, created_at, updated_at,
        notes)
      SELECT user_id,
             manga_id AS media_id,
             'Manga' AS media_type,
             chapters_read AS progress,
             status AS status,
             volumes_read AS volumes_owned,
             reread_count AS reconsume_count,
             rereading AS reconsuming,
             private,
             rating,
             created_at,
             coalesce(updated_at, created_at, now()),
             notes
      FROM manga_library_entries
    SQL

    # And finally remove the manga library entries table
    drop_table :manga_library_entries
  end
end
