class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.references :user
      t.string :action_type
      t.hstore :data

      t.timestamps
    end
    add_index :actions, :user_id
  end
end
