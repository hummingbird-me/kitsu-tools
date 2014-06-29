class AddNotesAndImportedToMangaLibraryEntry < ActiveRecord::Migration
  def change
    add_column :manga_library_entries, :notes, :string
    add_column :manga_library_entries, :imported, :boolean, :default => false, :null => false
  end
end
