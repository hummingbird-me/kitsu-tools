class Watchlist < ActiveRecord::Base
  belongs_to :user
  belongs_to :anime
  attr_accessible :positive, :status

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
end
