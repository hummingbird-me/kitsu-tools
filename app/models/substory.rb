# == Schema Information
#
# Table name: substories
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  story_id      :integer
#  target_id     :integer
#  target_type   :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  data          :hstore
#  substory_type :integer          default(0), not null
#  deleted_at    :datetime
#

class Substory < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :user
  belongs_to :target, polymorphic: true
  belongs_to :story
  validates :user, :substory_type, presence: true

  enum substory_type: [:followed, :watchlist_status_update, :comment,
                            :watched_episode, :reply]

  has_many :notifications, as: :source, dependent: :destroy

  scope :unbanned, ->{ eager_load(:user).where(users: { ninja_banned: false }) }

  def can_be_deleted_by?(user)
    return false if user.nil?
    self.user_id == user.id || self.story.can_be_deleted_by?(user)
  end

  def update_story_last_update_time!
    substories = self.story.reload.substories
    if substories && substories.length > 0
      self.story.set_last_update_time! substories.map {|x| x.created_at }.max
    end
  end

  after_create do
    update_story_last_update_time!
    StoryFanoutWorker.perform_async(self.user_id, self.story_id)
  end

  after_destroy do
    unless self.story.nil?
      if self.story and self.story.reload.substories.length == 0
        self.story.destroy!
      else
        update_story_last_update_time!
      end
    end
  end

  before_save do
    if data && body = data['comment'] || data[:comment]
      h = data.dup
      h['formatted_comment'] = MessageFormatter.format_message body
      self.data = h
    end
  end

  # TODO: Deprecate this in favour of the Action service.
  def self.from_action(data)
    user = User.find data[:user_id]

    if data[:action_type] == "followed"
      followed_user = User.find data[:followed_id]

      # Find or create a user story for this follow action.
      # If there already is a followed story for this user that was created less
      # than 6 hours ago, use that one. Otherwise create a new one.
      story = user.stories.where(story_type: 'followed').order("created_at DESC").limit(1)
      if story.length == 1 and story[0].created_at >= 6.hours.ago
        story = story[0]
      else
        story = Story.create user: user, story_type: "followed"
      end

      substory = Substory.create({
        user: user,
        substory_type: Substory.substory_types[:followed],
        target: followed_user,
        story: story
      })

    elsif data[:action_type] == "unfollowed"

      followed_user = User.find data[:followed_id]

      Substory.where(user_id: user.id, substory_type: Substory.substory_types[:followed], target_id: followed_user.id, target_type: "User").each {|x| x.destroy }


    elsif data[:action_type] == "watchlist_status_update"

      anime = Anime.find data[:anime_id]
      story = Story.for_user_and_anime(user, anime)

      substory = Substory.create({
        user: user,
        substory_type: Substory.substory_types[:watchlist_status_update],
        story: story,
        data: {
          old_status: data[:old_status],
          new_status: data[:new_status]
        }
      })

      if data[:time]
        substory.update_column :created_at, data[:time]
      end

    elsif data[:action_type] == "watched_episode"

      anime = Anime.find data[:anime_id]
      story = Story.for_user_and_anime(user, anime)

      Substory.create({
        user: user,
        substory_type: Substory.substory_types[:watched_episode],
        story: story,
        data: {
          episode_number: data[:episode_number],
          service: data[:service]
        }
      })

    end
  end
end
