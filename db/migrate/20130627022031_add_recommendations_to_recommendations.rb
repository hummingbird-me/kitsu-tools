class AddRecommendationsToRecommendations < ActiveRecord::Migration
  def change
    add_column :recommendations, :recommendations, :hstore
  end
end
