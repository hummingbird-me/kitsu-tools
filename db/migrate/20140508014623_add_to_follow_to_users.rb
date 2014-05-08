class AddToFollowToUsers < ActiveRecord::Migration
  def change
    add_column :users, :to_follow, :boolean, default: false
    add_index :users, :to_follow
  end
end
