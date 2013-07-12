class AddHistoricStoryUpdateTime < ActiveRecord::Migration
  def up
    User.find_each do |user|
      stories = Story.where(user_id: user).order('updated_at DESC').limit(1)
      if stories.length > 0
        story = stories[0]
        UserTimeline.notify_story_updated(user, story.updated_at)
      end
    end
  end

  def down
  end
end
