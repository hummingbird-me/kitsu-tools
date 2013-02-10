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
end
