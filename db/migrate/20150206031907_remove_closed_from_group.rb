class RemoveClosedFromGroup < ActiveRecord::Migration
  def change
    remove_column :groups, :closed
  end
end
