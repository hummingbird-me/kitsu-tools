class AddAnimeGenresIndices < ActiveRecord::Migration
  def change
    add_index :anime_genres, :genre_id
    add_index :anime_genres, :anime_id
  end
end
