class AddAttachmentImageToPeople < ActiveRecord::Migration
  def self.up
    change_table :people do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :people, :image
  end
end
