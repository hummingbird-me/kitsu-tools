# This migration comes from forem (originally 20111103210835)
class CreateForemCategories < ActiveRecord::Migration
  def change
    create_table :forem_categories do |t|
      t.string :name, :null => false
      t.timestamps
    end
  end
end
