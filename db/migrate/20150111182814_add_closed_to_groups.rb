class AddClosedToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :closed, :boolean, null: false, default: false
  end
end
