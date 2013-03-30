class AddAttachmentImageToCharacters < ActiveRecord::Migration
  def self.up
    change_table :characters do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :characters, :image
  end
end
