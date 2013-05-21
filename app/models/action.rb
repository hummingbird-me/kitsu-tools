class Action
  # TODO extract this code into a separate component (irisviel) if it becomes a
  # bottleneck. The problem is that the way things are now it is getting executed
  # in the HTTP request-response cycle.
  # FIXME thread-safety is still an issue. Just extract it out. :(
  def self.create(data)
    user = User.find data[:user_id]
    if data[:action_type] == "followed"
      
      followed_user = User.find data[:followed_id]

      # Check whether there is a recent followed story for this user.
      # If the user has a followed story in the last 6 hours, merge with it.
      # Otherwise create a new one.
      rs = user.stories.where(story_type: 'followed').order("created_at DESC").limit(1)
      if rs.length == 1 and rs[0].created_at >= 6.hours.ago
        story = rs[0]
        unless story.followed_users.include? followed_user
          story.data["followed_users"] = followed_user.id.to_s + "," + story.data["followed_users"]
          story.save
        end
      else
        Story.create user: user, story_type: "followed", data: {
          followed_users: [followed_user.id].map(&:to_s) * ','
        }
      end
    
    elsif data[:action_type] == "liked_quote"

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
