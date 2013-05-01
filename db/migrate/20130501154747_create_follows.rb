class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|
      t.references :user
      t.references :followed

      t.timestamps
    end
    add_index :follows, :user_id
    add_index :follows, :followed_id
  end
end
