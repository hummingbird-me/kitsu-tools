class RemoveCoverImageUrlFromAnime < ActiveRecord::Migration
  def up
    remove_column :anime, :cover_image_url
  end

  def down
    add_column :anime, :cover_image_url, :string
  end
end
