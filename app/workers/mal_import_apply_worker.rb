class MALImportApplyWorker
  include Sidekiq::Worker

  def perform(user_id)
    @user = User.find(user_id)
    @staged_import = @user.staged_import
    unless @staged_import.nil? or !@staged_import.data[:complete]
      @watchlist = MalImport.get_watchlist_from_staged_import(@staged_import)
      @reviews   = MalImport.get_reviews_from_staged_import(@staged_import)
      
      @user.transaction do
        @reviews.each {|x| x.save }

        @watchlist.each do |x|
          wl = x[1]
          if wl.status != "Completed" and wl.episodes_watched > 0 and wl.anime.episodes.length > wl.episodes_watched
            wl.update_episode_count w1.episodes_watched
          end
          wl.save
        end
        
        @user.staged_import = nil
        @user.save
        @user.recompute_life_spent_on_anime
      end
    end
  end
end
