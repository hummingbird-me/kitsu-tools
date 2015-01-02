class CreateGroupMembers < ActiveRecord::Migration
  def change
    create_table :group_members do |t|
      t.references :user, index: true, null: false
      t.references :group, index: true, null: false
      t.boolean :admin, null: false, default: false
      t.boolean :pending, null: false, default: true

      t.index [:user_id, :group_id], unique: true
      t.timestamps
    end
  end
end
