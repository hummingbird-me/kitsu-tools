class CreateAppsTable < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.references :creator, null: false
      t.string :key, null: false
      t.string :secret, null: false
      t.string :name, null: false

      t.index :key, unique: true
      t.index :name, unique: true
      t.index :creator_id
    end
  end
end
