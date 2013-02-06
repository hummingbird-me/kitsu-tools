# This migration comes from forem (originally 20120222204450)
class CreateForemMemberships < ActiveRecord::Migration
  def change
    create_table :forem_memberships do |t|
      t.integer :group_id
      t.integer :member_id
    end

    add_index :forem_memberships, :group_id
  end
end
