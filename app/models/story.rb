class Story < ActiveRecord::Base
  belongs_to :user
  attr_accessible :data, :story_type, :user
  serialize :data, ActiveRecord::Coders::Hstore
  
  validates :user, :story_type, presence: true
  
  def followed_users
    if story_type == "followed"
      ids = data["followed_users"].split(',').map &:to_i
      return ids.map {|x| User.find(x) }
    end
  end

  def quote
    if story_type == "liked_quote"
      return Quote.find data["quote_id"]
    end
  end
end
