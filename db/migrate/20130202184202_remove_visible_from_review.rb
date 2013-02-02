class RemoveVisibleFromReview < ActiveRecord::Migration
  def up
    remove_column :reviews, :visible
  end

  def down
    add_column :reviews, :visible, :boolean
  end
end
