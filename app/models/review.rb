class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :anime
  attr_accessible :content, :positive, :user, :anime

  validates :user, :anime, :content, :positive, :presence => true

  has_reputation :votes, source: :user, aggregated_by: :average, source_of: [
    {reputation: :karma, of: :user}
  ]

  def negative?
    not positive?
  end
end
