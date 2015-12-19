class CleanManga < ActiveRecord::Migration
  def change
    # => Titles
    add_column :manga, :titles, :hstore, default: '', null: false
    add_column :manga, :canonical_title, :string, null: false, default: 'ja_en'
    add_column :manga, :abbreviated_titles, :string, array: true
    execute <<-SQL
      UPDATE manga
      SET titles = hstore(ARRAY['ja_en', 'en'],
                          ARRAY[romaji_title, english_title])
    SQL
    remove_column :manga, :romaji_title
    remove_column :manga, :english_title

    # => Type
    change_column_default :manga, :manga_type, nil
    change_column :manga, :manga_type, "integer USING (
      CASE manga_type
      WHEN 'Manga' THEN 1
      WHEN 'Novel' THEN 2
      WHEN 'Manhua' THEN 3
      WHEN 'One Shot' THEN 4
      WHEN 'Doujin' THEN 5
      END
    )"
    change_column_default :manga, :manga_type, 1
    change_column_null :manga, :manga_type, false, 1

    # => Status
    change_column :manga, :status, "integer USING (
      CASE status
      WHEN 'Not Yet Published' THEN 1
      WHEN 'Publishing' THEN 2
      WHEN 'Finished' THEN 3
      END
    )"

    # => Synopsis
    change_column :manga, :synopsis, :text, null: true, default: nil
  end
end
