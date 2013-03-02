class RemoveForemFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :forem_admin
    remove_column :users, :forem_state
    remove_column :users, :forem_auto_subscribe
  end

  def down
    add_column :users, :forem_auto_subscribe, :boolean
    add_column :users, :forem_state, :string
    add_column :users, :forem_admin, :boolean
  end
end
