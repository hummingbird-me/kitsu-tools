class DeleteAllExistingRecommendations < ActiveRecord::Migration
  def up
    Recommendation.where({}).delete_all
  end

  def down
  end
end
