class CreateLists < ActiveRecord::Migration
  def change
    create_table :lists do |t|
      t.references :user, null: false, index: true
      t.string :title, null: false
      t.text :description
      t.integer :visibility, null: false, default: 0
      t.integer :type, null: false, default: 0
      t.integer :items_quantity, null: false, default: 0
      t.timestamps null: false
    end
  end
end
