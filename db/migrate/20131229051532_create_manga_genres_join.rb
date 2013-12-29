class CreateMangaGenresJoin < ActiveRecord::Migration
  def change
    create_table :genres_manga, id: false do |t|
      t.integer :manga_id, null: false
      t.integer :genre_id, null: false
    end

    add_index :genres_manga, :manga_id
    add_index :genres_manga, :genre_id
  end
end
