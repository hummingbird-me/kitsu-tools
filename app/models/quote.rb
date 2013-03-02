class Quote < ActiveRecord::Base
  attr_accessible :anime_id, :character_name, :content
  
  belongs_to :anime
  belongs_to :user
  
  def creator
    user
  end

  validates :content, :anime, :user, :presence => true

  has_reputation :votes, source: :user, source_of: [
    {reputation: :quote_votes, of: :user}
  ]
end
