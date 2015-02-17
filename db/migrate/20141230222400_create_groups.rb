class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name, unique: true, null: false
      t.string :slug, unique: true, index: true, null: false
      t.string :bio, default: '', null: false
      t.text :about, default: '', null: false
      t.has_attached_file :avatar
      t.has_attached_file :cover_image

      # Counter Cache
      t.integer :confirmed_members_count, default: 0

      t.timestamps
    end
  end
end
