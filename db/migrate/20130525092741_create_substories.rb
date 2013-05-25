class CreateSubstories < ActiveRecord::Migration
  def change
    create_table :substories do |t|
      t.references :user
      t.string :substory_type
      t.references :story
      t.references :target, polymorphic: true

      t.timestamps
    end
    add_index :substories, :user_id
    add_index :substories, :target_id
  end
end
