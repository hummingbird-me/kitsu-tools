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
#  total_votes  :integer          default(0), not null
#  group_id     :integer
#  deleted_at   :datetime
#

class Story < ActiveRecord::Base
  acts_as_paranoid

  attr_reader :is_liked
  attr_accessor :recent_likers

  belongs_to :watchlist
  belongs_to :user
  belongs_to :target, polymorphic: true
  belongs_to :group

  has_many :substories # This is not dependent: :destroy for performance reasons,
                       # substories are deleted in a background worker triggered
                       # in the after_destroy hook.

  has_many :notifications, as: :source, dependent: :destroy

  validates :user, :story_type, presence: true
  validates :group, presence: true, if: Proc.new {|s| s.group_id.present? }

  scope :unbanned, ->{ eager_load(:user).where(users: { ninja_banned: false }) }

  def self.for_user_and_anime(user, anime, story_type="media_story")
    story = user.stories.where(story_type: story_type, target_id: anime.id, target_type: "Anime")
    watchlist = Watchlist.find_by(user_id: user.id, anime_id: anime.id)
    if story.length > 0
      story = story[0]
      story.watchlist = watchlist
      story.adult = (not anime.sfw?)
      story.save!
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

  # Can this story be deleted by the specified user?
  def can_be_deleted_by?(user)
    return false if user.nil?
    user.admin? || user.id == self.user_id || user.id == self.target_id ||
      (self.group.present? && self.group.is_staff?(user))
  end
  alias_method :can_toggle_nsfw?, :can_be_deleted_by?

  def set_is_liked!(v)
    @is_liked = v
  end

  after_destroy do
    SubstoryReaperWorker.perform_async(self.id)
  end
end
