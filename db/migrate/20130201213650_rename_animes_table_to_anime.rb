class RenameAnimesTableToAnime < ActiveRecord::Migration
  def up
    rename_table :animes, :anime
  end

  def down
    rename_table :anime, :animes
  end
end
