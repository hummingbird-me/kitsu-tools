class AddCoverImageTopOffsetToAnime < ActiveRecord::Migration
  def change
    add_column :anime, :cover_image_top_offset, :integer
  end
end
