class Story < ActiveRecord::Base
  belongs_to :user
  has_many :substories, dependent: :destroy
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
    if %w[liked_quote submitted_quote].include? story_type
      return Quote.find data["quote_id"]
    end
  end

  def anime
    if %w[watchlist_status_update].include? story_type
      return Anime.find data["anime_id"]
    end
  end
end
