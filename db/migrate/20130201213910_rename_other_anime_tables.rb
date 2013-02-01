class RenameOtherAnimeTables < ActiveRecord::Migration
  def up
    rename_table :animes_genres, :anime_genres
    rename_table :animes_producers, :anime_producers
  end

  def down
    rename_table :anime_genres, :animes_genres
    rename_table :anime_producers, :animes_producers
  end
end
