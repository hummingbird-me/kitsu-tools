class Story < ActiveRecord::Base
  belongs_to :user
  belongs_to :target, polymorphic: true
  has_many :substories, dependent: :destroy
  attr_accessible :data, :story_type, :user, :target

  serialize :data, ActiveRecord::Coders::Hstore
  
  validates :user, :story_type, presence: true
  
  def self.for_user_and_anime(user, anime, story_type="media_story")
    story = user.stories.where(story_type: story_type, target_id: anime.id, target_type: "Anime")
    if story.length > 0
      story = story[0]
    else
      story = Story.create user: user, story_type: story_type, target: anime
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
