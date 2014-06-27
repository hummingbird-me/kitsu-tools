class CreateMangaLibraryEntries < ActiveRecord::Migration
  def change
    create_table :manga_library_entries do |t|
      t.references :user, index: true
      t.references :manga, index: true
      t.string :status
      t.boolean :private, :default => false
      t.integer :chapters_readed, :default => 0
      t.integer :volumes_readed, :default => 0
      t.integer :rereading_count, :default => 0
      t.boolean :rereading, :default => false
      t.datetime :last_readed
      t.decimal :rating, :precision => 2, :scale => 1
      t.timestamps
    end
  end
end


