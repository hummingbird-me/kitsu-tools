class RemoveCoverImageProcessingFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :cover_image_processing
  end

  def down
    add_column :users, :cover_image_processing, :boolean
  end
end
