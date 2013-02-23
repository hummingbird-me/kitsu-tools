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
end
