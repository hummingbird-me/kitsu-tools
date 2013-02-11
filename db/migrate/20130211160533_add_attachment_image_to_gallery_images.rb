class AddAttachmentImageToGalleryImages < ActiveRecord::Migration
  def self.up
    change_table :gallery_images do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :gallery_images, :image
  end
end
