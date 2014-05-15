class AddSlugIndexOnAnime < ActiveRecord::Migration
  def change
    add_index :anime, :slug, unique: true
  end
end
