class AddTitleToAnime < ActiveRecord::Migration
  def change
    add_column :animes, :title, :string
  end
end
