class EpisodeView < ActiveRecord::Base
  belongs_to :episode
  belongs_to :watchlist
  attr_accessible :watchlist, :episode
  
  def user; watchlist.user; end
  def anime; watchlist.anime; end
  
  validates :watchlist, presence: true

  # After saving, update the "last_watched" time of the corresponding Watchlist.
  # Also update the amount of time the user has spent watching anime.
  after_save do
    user.update_life_spent_on_anime(episode.length)
    watchlist.update_attributes(last_watched: self.created_at)
  end
  
  # After deleting, update the amount of time the user has spent watching anime.
  after_destroy do
    user.update_life_spent_on_anime(-episode.length)
  end
end
