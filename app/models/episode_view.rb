class EpisodeView < ActiveRecord::Base
  belongs_to :user
  belongs_to :anime
  belongs_to :episode
  
  attr_accessible :user, :anime, :episode
  
  validate :cached_anime_id_must_equal_episode_anime_id
  def cached_anime_id_must_equal_episode_anime_id
    if anime_id != episode.anime_id
      errors.add(:anime, "identifier does not match episode. Please report this errror.")
    end
  end
  
  # TODO: Validate presence of watchlist.

  # After saving, update the "last_watched" time of the corresponding Watchlist.
  # Also update the amount of time the user has spent watching anime.
  after_save do
    user.update_life_spent_on_anime(episode.length)
    Watchlist.where(user_id: self.user, anime_id: self.anime).first.update_attributes(last_watched: self.created_at)
  end
  
  # After deleting, update the amount of time the user has spent watching anime.
  before_destroy do
    user.update_life_spent_on_anime(-episode.length)
  end
end
