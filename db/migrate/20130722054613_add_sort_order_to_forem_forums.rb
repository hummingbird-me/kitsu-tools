class AddSortOrderToForemForums < ActiveRecord::Migration
  def change
    add_column :forem_forums, :sort_order, :integer
  end
end
