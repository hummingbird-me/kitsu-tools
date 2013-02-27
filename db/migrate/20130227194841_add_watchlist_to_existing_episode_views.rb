class AddWatchlistToExistingEpisodeViews < ActiveRecord::Migration
  def up
    EpisodeView.all.map {|x| x.watchlist = Watchlist.where(user_id: x.user_id, anime_id: x.anime_id).first; x }.each {|x| x.save rescue x.destroy }
  end
  
  def down
  end
end
