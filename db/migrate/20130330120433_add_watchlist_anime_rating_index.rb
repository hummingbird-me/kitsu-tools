class AddWatchlistAnimeRatingIndex < ActiveRecord::Migration
  def change
    add_index :watchlists, [:anime_id, :rating]
  end
end
