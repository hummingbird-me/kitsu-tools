# == Schema Information
#
# Table name: stories
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  data         :hstore
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  story_type   :string(255)
#  target_id    :integer
#  target_type  :string(255)
#  watchlist_id :integer
#  adult        :boolean          default(FALSE)
#

class Story < ActiveRecord::Base
  belongs_to :watchlist
  belongs_to :user
  belongs_to :target, polymorphic: true
  has_many :substories, dependent: :destroy
  attr_accessible :data, :story_type, :user, :target, :watchlist, :adult

  has_many :notifications, as: :source, dependent: :destroy

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

  def set_last_update_time!(time=nil)
    time ||= Time.now
    self.updated_at = time
    self.save
  end

  def self.for_user(user)
    if user.nil? or user.sfw_filter
      where("NOT adult").joins("LEFT OUTER JOIN watchlists ON watchlists.id = stories.watchlist_id").where("watchlists.id IS NULL OR watchlists.private = 'f'")
    else
      joins("LEFT OUTER JOIN watchlists ON watchlists.id = stories.watchlist_id").where("watchlists.id IS NULL OR watchlists.private = 'f'")
    end
  end
end
