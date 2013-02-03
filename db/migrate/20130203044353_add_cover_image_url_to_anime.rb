class AddCoverImageUrlToAnime < ActiveRecord::Migration
  def change
    add_column :anime, :cover_image_url, :string
  end
end
