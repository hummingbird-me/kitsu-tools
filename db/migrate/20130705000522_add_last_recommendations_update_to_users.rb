class AddLastRecommendationsUpdateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_recommendations_update, :datetime
  end
end
