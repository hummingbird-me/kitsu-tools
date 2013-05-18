class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.references :user
      t.hstore :data

      t.timestamps
    end
    add_index :stories, :user_id
  end
end
