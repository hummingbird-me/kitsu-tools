class RenameStuffOnMangaLibraryEntry < ActiveRecord::Migration
  def change
    rename_column :manga_library_entries, :chapters_readed, :chapters_read
    rename_column :manga_library_entries, :volumes_readed, :volumes_read
    rename_column :manga_library_entries, :last_readed, :last_read
  end
end
