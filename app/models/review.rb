require 'wilson_score'

class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :anime
  attr_accessible :content, :user, :anime, :source, :rating, :rating_animation,
    :rating_sound, :rating_character, :rating_enjoyment, :rating_story, 
    :summary

  validates :user, :anime, :content, :rating, :presence => true

  # Don't allow a user to review an anime more than once.
  validates :user_id, :uniqueness => {:scope => :anime_id}

  has_reputation :votes, source: :user, source_of: [
    {reputation: :review_votes, of: :user}
  ]

  def update_wilson_score!
    positive = self.reputation_for(:votes)
    total = self.evaluations.count
    self.update_column :wilson_score, WilsonScore.lower_bound(positive, total)
  end
end
