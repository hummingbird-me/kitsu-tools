class RemoveTypeFromCasting < ActiveRecord::Migration
  def up
    remove_column :castings, :type
  end

  def down
    add_column :castings, :type, :string
  end
end
