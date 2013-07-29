class AddOrderToCastings < ActiveRecord::Migration
  def change
    add_column :castings, :order, :integer
  end
end
