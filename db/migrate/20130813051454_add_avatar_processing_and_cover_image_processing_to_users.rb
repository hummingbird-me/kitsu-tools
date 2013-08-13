class AddAvatarProcessingAndCoverImageProcessingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar_processing, :boolean
    add_column :users, :cover_image_processing, :boolean
  end
end
