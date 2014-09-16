class RemoveSubstoryTypeOldFromSubstories < ActiveRecord::Migration
  def change
    remove_column :substories, :substory_type_old, :string
  end
end
