class AddAltTitleToAnime < ActiveRecord::Migration
  def change
    add_column :anime, :alt_title, :string
  end
end
