class Watchlist < ActiveRecord::Base
  belongs_to :user
  belongs_to :anime
  attr_accessible :user, :anime, :positive, :status

  validates_uniqueness_of :user_id, :scope => :anime_id

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

  # Handle state transitions intelligently. There are a lot of subtleties
  # here, be careful while adding additional transition handling logic here, and
  # definitely consider how different UI flows are affected. 
  #
  # If `episodes_watched` is equal to the total number of episodes, automatically
  # mark the anime as "Completed".
  #
  # TODO: If the user updates an episode as viewed, the state _must_ be either
  #       "Currently Watching" or "Completed". The "Completed" case is handled
  #       here, but we also need to handle the "Currently Watching" case.
  before_save do
    if episodes_watched == anime.episode_count
      self.status = "Completed"
    end
  end
end
