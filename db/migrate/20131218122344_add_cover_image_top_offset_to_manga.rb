class AddCoverImageTopOffsetToManga < ActiveRecord::Migration
  def change
    add_column :manga, :cover_image_top_offset, :integer, default: 0
  end
end
