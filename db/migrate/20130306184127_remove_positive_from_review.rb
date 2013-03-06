class RemovePositiveFromReview < ActiveRecord::Migration
  def up
    remove_column :reviews, :positive
  end

  def down
    add_column :reviews, :positive, :boolean
  end
end
