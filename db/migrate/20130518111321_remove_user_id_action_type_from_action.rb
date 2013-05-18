class RemoveUserIdActionTypeFromAction < ActiveRecord::Migration
  def up
    remove_column :actions, :user_id
    remove_column :actions, :action_type
  end

  def down
    add_column :actions, :action_type, :string
    add_column :actions, :user_id, :integer
  end
end
