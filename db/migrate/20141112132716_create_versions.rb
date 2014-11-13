class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.references :item, polymorphic: true, null: false
      t.references :user

      t.json :object, null: false
      t.json :object_changes, null: false

      t.integer :state, default: 0

      t.timestamps
    end

    add_index :versions, [:item_type, :item_id]
    add_index :versions, [:user_id]
  end
end
