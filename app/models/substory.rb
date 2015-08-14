# == Schema Information
#
# Table name: substories
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  story_id    :integer
#  target_id   :integer
#  target_type :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  data        :hstore
#  type        :integer          default(0), not null
#  deleted_at  :datetime
#

class Substory < ActiveRecord::Base
  include EnumeratedInheritance
  acts_as_paranoid
  sti_enum 0 => 'Substory::FollowSubstory',  # followed
           1 => 'Substory::LibrarySubstory',   # watchlist_status_update
           2 => 'Substory::CommentSubstory',   # comment
           3 => 'Substory::EpisodeSubstory',   # watched_episode
           4 => 'Substory::ReplySubstory'      # reply

  belongs_to :user
  belongs_to :target, polymorphic: true
  belongs_to :story
  has_many :notifications, as: :source, dependent: :destroy

  scope :unbanned, ->{ eager_load(:user).where(users: { ninja_banned: false }) }

  def can_edit?(user)
    return false if user.nil?
    user_id == user.id || story.can_edit?(user)
  end

  def bump_story!
    substories = story.reload.substories
    if substories && substories.length > 0
      story.bump!(substories.map(&:created_at).max)
    end
  end

  def build_for_story(story, obj={})
    story = story.id if story.is_a? Story
    new({story_id: story}.merge(obj))
  end

  after_create do
    bump_story!
    StoryFanoutWorker.perform_async(user_id, story_id)
  end

  after_destroy do
    unless story.nil?
      # Delete the Story if there's no more Substories
      if story && story.reload.substories.length == 0
        story.destroy!
      else
        bump_story!
      end
    end
  end

  # DEPRECATED: Use STI subclasses instead
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
