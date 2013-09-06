class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.references :user
      t.references :item, polymorphic: true

      t.timestamps
    end
    add_index :favorites, :user_id
    add_index :favorites, [:item_id, :item_type]
    add_index :favorites, [:user_id, :item_id, :item_type], unique: true
  end
end
