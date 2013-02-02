class RemoveVisibleFromQuote < ActiveRecord::Migration
  def up
    remove_column :quotes, :visible
  end

  def down
    add_column :quotes, :visible, :boolean
  end
end
