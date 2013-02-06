# This migration comes from forem (originally 20120223162058)
class CreateForemModeratorGroups < ActiveRecord::Migration
  def change
    create_table :forem_moderator_groups do |t|
      t.integer :forum_id
      t.integer :group_id
    end

    add_index :forem_moderator_groups, :forum_id
  end
end
