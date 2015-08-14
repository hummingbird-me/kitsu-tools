# == Schema Information
#
# Table name: stories
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  data             :hstore
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  target_id        :integer
#  target_type      :string(255)
#  library_entry_id :integer
#  adult            :boolean          default(FALSE)
#  total_votes      :integer          default(0), not null
#  group_id         :integer
#  deleted_at       :datetime
#  type             :integer          not null
#

class Story < ActiveRecord::Base
  include EnumeratedInheritance
  acts_as_paranoid
  sti_enum 0 => 'Story::LibraryStory',
           1 => 'Story::CommentStory',
           2 => 'Story::FollowStory'

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

  validates :user, presence: true

  scope :unbanned, ->{ eager_load(:user).where(users: { ninja_banned: false }) }

  def bump!(time=nil)
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

  # Can this story be edited by the specified user?
  def can_edit?(user)
    return false if user.nil?
    user.admin? || user.id == self.user_id || user.id == self.target_id ||
      (self.group.present? && self.group.is_staff?(user))
  end
  alias_method :can_toggle_nsfw?, :can_edit?
  alias_method :can_be_deleted_by?, :can_edit?

  def set_is_liked!(v)
    @is_liked = v
  end

  after_destroy do
    SubstoryReaperWorker.perform_async(self.id)
  end
end
