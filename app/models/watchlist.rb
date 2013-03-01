class Watchlist < ActiveRecord::Base
  belongs_to :user
  belongs_to :anime
  attr_accessible :user, :anime, :status, :episodes_watched, 
    :updated_at, :last_watched

  validates_uniqueness_of :user_id, :scope => :anime_id

  has_and_belongs_to_many :episodes, :uniq => true

  # Return an array of possible valid statuses.
  def self.valid_statuses
    ["Currently Watching", "Plan to Watch", "Completed", "On Hold", "Dropped"]
  end  
  
  validates :status, inclusion: { in: Watchlist.valid_statuses }

  def positive?
    rating && rating > 0
  end

  def negative?
    rating && rating < 0
  end

  # This method will take an array of "watchlist" object IDs and return a unique
  # string hash. This is used to check whether a user's recommendations are up to
  # date.
  def self.watchlist_hash(watchlist_ids)
    Digest::MD5.hexdigest( watchlist_ids.sort * ' ' )
  end

  # If the "last_watched" time is not set, set it to updated_at time.
  #
  # Update the number of episodes watched.
  #
  # If the status is set to "Completed", then before saving mark all episodes as
  # viewed.
  before_save do
    if self.last_watched.nil?
      self.last_watched = self.updated_at
    end
    
    self.episodes_watched = self.episodes.length

    if self.status == "Completed"
      self.episodes = self.anime.episodes
    end
  end
end
