# == Schema Information
#
# Table name: stories
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  data             :hstore
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  story_type       :string(255)
#  target_id        :integer
#  target_type      :string(255)
#  library_entry_id :integer
#  adult            :boolean          default(FALSE)
#  total_votes      :integer          default(0), not null
#  group_id         :integer
#  deleted_at       :datetime
#

class Story < ActiveRecord::Base
  acts_as_paranoid

  attr_reader :is_liked
  attr_accessor :recent_likers

  belongs_to :library_entry
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
    entry = LibraryEntry.find_by(user_id: user.id, anime_id: anime.id)
    if story.length > 0
      story = story[0]
      story.library_entry = entry
      story.adult = (!anime.sfw?)
      story.save!
    else
      story = Story.create(
        user: user,
        story_type: story_type,
        target: anime,
        library_entry: entry,
        adult: (!anime.sfw?)
      )
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
    query = joins("LEFT OUTER JOIN library_entries ON library_entries.id = stories.library_entry_id")
            .where("library_entries.id IS NULL OR library_entries.private = 'f'")
    query = query.where.not(adult: true) if user.nil? || user.sfw_filter
    query
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
