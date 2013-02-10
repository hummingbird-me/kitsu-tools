class Watchlist < ActiveRecord::Base
  belongs_to :user
  belongs_to :anime
  attr_accessible :user, :anime, :positive, :status

  validates_uniqueness_of :user_id, :scope => :anime_id

  def status
    s = read_attribute(:status)
    if s.nil?
      # TODO later, check the number of episodes watched and return
      #       "Finished Watching" instead if appropriate.
      return "Currently Watching"
    else
      return s
    end
  end

  def positive?
    (not positive.nil?) and positive
  end

  def negative?
    (not positive.nil?) and (not positive)
  end

  # This method will take an array of "watchlist" object IDs and return a unique
  # string hash. This is used to check whether a user's recommendations are up to
  # date.
  def self.watchlist_hash(watchlist_ids)
    Digest::MD5.hexdigest( watchlist_ids.sort * ' ' )
  end
end
