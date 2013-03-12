class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :anime
  attr_accessible :content, :user, :anime, :source, :rating, :rating_animation, 
    :rating_sound, :rating_character, :rating_enjoyment, :rating_story, :summary

  validates :user, :anime, :content, :presence => true
  
  # Don't allow a user to review an anime more than once.
  validates :user_id, :uniqueness => {:scope => :anime_id}

  has_reputation :votes, source: :user, source_of: [
    {reputation: :review_votes, of: :user}
  ]
end
