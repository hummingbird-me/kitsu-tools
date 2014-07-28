class RemoveForemFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :forem_admin
    remove_column :users, :forem_state
    remove_column :users, :forem_auto_subscribe
  end
end
