class AddRatingToConsuming < ActiveRecord::Migration
  def change
    add_column :consumings, :rating, :decimal, :precision => 2, :scale => 1
  end
end
