class RenameMoreStuffOnMangaLibraryEntry < ActiveRecord::Migration
  def change
    rename_column :manga_library_entries, :rereading_count, :reread_count
  end
end
