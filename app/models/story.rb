class Story < ActiveRecord::Base
  belongs_to :watchlist
  belongs_to :user
  belongs_to :target, polymorphic: true
  has_many :substories, dependent: :destroy
  attr_accessible :data, :story_type, :user, :target, :watchlist, :adult

  serialize :data, ActiveRecord::Coders::Hstore
  
  validates :user, :story_type, presence: true
  
  def self.for_user_and_anime(user, anime, story_type="media_story")
    story = user.stories.where(story_type: story_type, target_id: anime.id, target_type: "Anime")
    watchlist = Watchlist.find_by_user_id_and_anime_id(user.id, anime.id)
    if story.length > 0
      story = story[0]
      story.watchlist = watchlist
      story.adult = (not anime.sfw?)
      story.save
    else
      story = Story.create user: user, story_type: story_type, target: anime, watchlist: watchlist, adult: (not anime.sfw?)
    end
    story
  end
  
  def quote
    return Quote.find data["quote_id"]
  end

  def anime
    if %w[watchlist_status_update].include? story_type
      return Anime.find data["anime_id"]
    end
  end
end
