class AddWatchlistHashAndRecommendationsUpToDateToUser < ActiveRecord::Migration
  def change
    add_column :users, :watchlist_hash, :string
    add_column :users, :recommendations_up_to_date, :boolean
  end
end
