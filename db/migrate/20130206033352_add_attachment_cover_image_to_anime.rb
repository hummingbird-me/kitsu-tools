class AddAttachmentCoverImageToAnime < ActiveRecord::Migration
  def self.up
    change_table :anime do |t|
      t.attachment :cover_image
    end
  end

  def self.down
    drop_attached_file :anime, :cover_image
  end
end
