class EpisodeView < ActiveRecord::Base
  belongs_to :episode
  belongs_to :watchlist
  attr_accessible :watchlist, :episode
  
  def user; watchlist.user; end
  def anime; watchlist.anime; end
  
  validates :watchlist, presence: true

  # Before saving, update the "last_watched" time of the corresponding Watchlist.
  # Also update the amount of time the user has spent watching anime.
  before_save do
    user.update_life_spent_on_anime(episode.length)
    watchlist.last_watched = self.created_at
    watchlist.episodes_watched += 1
    watchlist.save
  end
  
  # Before deleting, update the amount of time the user has spent watching anime.
  before_destroy do
    watchlist.episodes_watched -= 1; watchlist.save
    user.update_life_spent_on_anime(-episode.length)
  end
end
