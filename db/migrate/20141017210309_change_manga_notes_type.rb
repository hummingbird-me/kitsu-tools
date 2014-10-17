class ChangeMangaNotesType < ActiveRecord::Migration
  def change

    change_column(:manga_library_entries, :notes, :text)

  end
end
