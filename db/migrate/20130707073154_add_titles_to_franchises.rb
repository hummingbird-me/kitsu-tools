class AddTitlesToFranchises < ActiveRecord::Migration
  def change
    add_column :franchises, :english_title, :string
    add_column :franchises, :romaji_title, :string
  end
end
