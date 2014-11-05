class CreateCustomListTables < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.integer :user_id, null: false
      t.string :list_name, null: false
      t.string :media_type, null: false

      t.index :user_id
    end

    create_table :list_items do |t|
      t.integer :list_id, null: false
      t.integer :order, null: false
      t.integer :media_id, null: false
      t.string :notes, null: false, default: ""

      t.index :list_id
      t.index [:list_id, :media_id], unique: true
    end
  end
end
