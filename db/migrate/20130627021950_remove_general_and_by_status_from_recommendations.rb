class RemoveGeneralAndByStatusFromRecommendations < ActiveRecord::Migration
  def up
    remove_column :recommendations, :general
    remove_column :recommendations, :by_status
  end

  def down
    add_column :recommendations, :by_status, :hstore
    add_column :recommendations, :general, :hstore
  end
end
