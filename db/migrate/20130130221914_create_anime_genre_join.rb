class CreateAnimeGenreJoin < ActiveRecord::Migration
  def change
    create_table :animes_genres, :id => false do |t|
      t.integer :anime_id, :null => false
      t.integer :genre_id, :null => false
    end
  end
end
