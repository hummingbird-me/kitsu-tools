class AddCategoryToRecommendations < ActiveRecord::Migration
  def change
    add_column :recommendations, :category, :string
  end
end
