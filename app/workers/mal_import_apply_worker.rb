class MALImportApplyWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    staged_import = user.staged_import
    unless staged_import.nil? or !staged_import.data[:complete]
      watchlist = MalImport.get_watchlist_from_staged_import(staged_import)
      reviews   = MalImport.get_reviews_from_staged_import(staged_import)

      user.transaction do
        reviews.each {|x| x.save }

        watchlist.each do |x|
          wl = x[1]
          wl.update_episode_count wl.episodes_watched
          wl.save
        end

        user.staged_import = nil
        user.save
        staged_import.destroy
        user.recompute_life_spent_on_anime
      end
    end
  end
end
