class AddEditFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :approved_edit_count, :integer, default: 0
    add_column :users, :rejected_edit_count, :integer, default: 0
  end
end
