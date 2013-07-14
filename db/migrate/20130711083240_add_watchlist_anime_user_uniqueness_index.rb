class AddWatchlistAnimeUserUniquenessIndex < ActiveRecord::Migration
  def up
    Watchlist.count(group: [:user_id, :anime_id]).select {|k, v| v > 1 }.each {|k, v| Watchlist.where(user_id: k[0], anime_id: k[1]).order(:updated_at).to_a[0..-2].each {|x| x.user.recompute_life_spent_on_anime; x.destroy } }
    add_index :watchlists, [:user_id, :anime_id], unique: true
  end
  
  def down
    remove_index :watchlists, [:user_id, :anime_id]
  end
end
