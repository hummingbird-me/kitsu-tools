class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user
      t.references :source, polymorphic: true
      t.hstore :data

      t.timestamps
    end

    add_index :notifications, :user_id
    add_index :notifications, :source_id
  end
end
