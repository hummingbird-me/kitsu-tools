class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :anime
  attr_accessible :content, :user, :anime, :rating, :source

  validates :user, :anime, :content, :presence => true
  
  # Don't allow a user to review an anime more than once.
  validates :user_id, :uniqueness => {:scope => :anime_id}

  has_reputation :votes, source: :user, source_of: [
    {reputation: :review_votes, of: :user}
  ]
end
