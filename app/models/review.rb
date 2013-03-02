class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :anime
  attr_accessible :content, :positive, :user, :anime, :rating, :source

  validates :user, :anime, :content, :presence => true

  has_reputation :votes, source: :user, source_of: [
    {reputation: :review_votes, of: :user}
  ]
end
