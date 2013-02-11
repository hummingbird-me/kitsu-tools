class CreateGalleryImages < ActiveRecord::Migration
  def change
    create_table :gallery_images do |t|
      t.references :anime
      t.text :description

      t.timestamps
    end
    add_index :gallery_images, :anime_id
  end
end
