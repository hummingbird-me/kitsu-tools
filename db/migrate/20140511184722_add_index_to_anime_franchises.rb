class AddIndexToAnimeFranchises < ActiveRecord::Migration
  def change
    add_index :anime_franchises, :anime_id
    add_index :anime_franchises, :franchise_id
  end
end
