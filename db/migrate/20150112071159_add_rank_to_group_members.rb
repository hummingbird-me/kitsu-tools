class AddRankToGroupMembers < ActiveRecord::Migration
  def change
    remove_column :group_members, :admin, :boolean
    add_column :group_members, :rank, :integer, null: false, default: 0
  end
end
