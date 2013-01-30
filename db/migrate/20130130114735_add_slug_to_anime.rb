class AddSlugToAnime < ActiveRecord::Migration
  def change
    add_column :animes, :slug, :string
    add_index :animes, :slug, :unique => true
  end
end
