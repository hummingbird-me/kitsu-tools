class AddFeaturedToCasting < ActiveRecord::Migration
  def change
    add_column :castings, :featured, :boolean
  end
end
