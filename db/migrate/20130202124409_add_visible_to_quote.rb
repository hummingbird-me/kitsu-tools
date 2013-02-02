class AddVisibleToQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :visible, :boolean
  end
end
