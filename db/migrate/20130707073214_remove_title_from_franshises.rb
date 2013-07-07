class RemoveTitleFromFranshises < ActiveRecord::Migration
  def up
    remove_column :franchises, :title
  end

  def down
    add_column :franchises, :title, :string
  end
end
