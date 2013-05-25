class Substory < ActiveRecord::Base
  belongs_to :user
  belongs_to :target, polymorphic: true
  belongs_to :story
  attr_accessible :user, :target, :story, :substory_type

  validates :user, :target, :substory_type, presence: true
  
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
      
      # Find the substory and delete it. If the parent story then ends up with 
      # zero substories, delete the parent story as well.
      substory = Substory.where(user_id: user.id, substory_type: "followed", target_id: followed_user.id, target_type: "User")
      if substory.length > 0
        substory = substory[0]
        if substory.story.substories.length == 1
          substory.story.destroy
        else
          substory.destroy
        end
      end
      
    end

    return
    user = User.find data[:user_id]
    if data[:action_type] == "liked_quote"

      # No aggregation.
      # Only if the user doesn't already have a "story" for this quote.
      quote = Quote.find(data[:quote_id])
      if user.stories.where("data ? 'quote_id'").where("data -> 'quote_id' = :id", id: quote.id.to_s).count == 0
        story = Story.create user: user, story_type: "liked_quote", data: {
          quote_id: data[:quote_id],
        }
        story.updated_at = data[:time]
        story.save
      end
      
    elsif data[:action_type] == "submitted_quote"

      # No aggregation.
      # Only if the user doesn't already have a "story" for this quote.
      quote = Quote.find(data[:quote_id])
      if user.stories.where("data ? 'quote_id'").where("data -> 'quote_id' = :id", id: quote.id.to_s).count == 0
        story = Story.create user: user, story_type: "submitted_quote", data: {
          quote_id: data[:quote_id]
        }
        story.updated_at = data[:time]
        story.save
      end
      
    elsif data[:action_type] == "unliked_quote"
      
      # Delete the story for liking this quote.
      user.stories.where(story_type: 'liked_quote').where("data -> 'quote_id' = :id", id: data[:quote_id].to_s).each {|x| x.destroy }

    elsif data[:action_type] == "watchlist_status_update"

      # If the user has a watchlist_status_update story for this anime that was
      # updated in the last 2 hours, update that one. Otherwise create a new
      # story.
      rs = user.stories.where(story_type: 'watchlist_status_update').where("data -> 'anime_id' = :id", id: data[:anime_id].to_s).order('updated_at DESC').limit(1)
      if rs.length == 1 and rs[0].updated_at >= 2.hours.ago
        story = rs[0]
        story.data["old_status"] = data[:old_status]
        story.data["new_status"] = data[:new_status]
        story.updated_at = data[:time]
        story.save
      else
        story = Story.create user: user, story_type: "watchlist_status_update", data: {
          anime_id: data[:anime_id],
          old_status: data[:old_status],
          new_status: data[:new_status]
        }
        story.updated_at = data[:time]
        story.save
      end

    end
  end
end
