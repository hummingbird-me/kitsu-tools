class AddRecsToRecommendations < ActiveRecord::Migration
  def change
    add_column :recommendations, :general, :hstore
    add_column :recommendations, :by_status, :hstore
  end
end
