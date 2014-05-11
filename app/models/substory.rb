# == Schema Information
#
# Table name: substories
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  substory_type :string(255)
#  story_id      :integer
#  target_id     :integer
#  target_type   :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  data          :hstore
#

class Substory < ActiveRecord::Base
  belongs_to :user
  belongs_to :target, polymorphic: true
  belongs_to :story
  attr_accessible :user, :target, :story, :substory_type, :data
  validates :user, :substory_type, presence: true

  after_create do
    self.story.set_last_update_time! self.created_at
    self.story.save
    StoryFanoutWorker.perform_async(self.user_id, self.story_id)
  end

  after_destroy do
    if self.story and self.story.reload.substories.length == 0
      self.story.destroy
    end
  end

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
        substory_type: "followed",
        target: followed_user,
        story: story
      })

    elsif data[:action_type] == "unfollowed"

      followed_user = User.find data[:followed_id]

      Substory.where(user_id: user.id, substory_type: "followed", target_id: followed_user.id, target_type: "User").each {|x| x.destroy }


    elsif data[:action_type] == "watchlist_status_update"

      anime = Anime.find data[:anime_id]
      story = Story.for_user_and_anime(user, anime)

      substory = Substory.create({
        user: user,
        substory_type: "watchlist_status_update",
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
        substory_type: "watched_episode",
        story: story,
        data: {
          episode_number: data[:episode_number],
          service: data[:service]
        }
      })

    end
  end
end
