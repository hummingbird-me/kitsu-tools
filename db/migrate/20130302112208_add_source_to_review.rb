class AddSourceToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :source, :string
  end
end
