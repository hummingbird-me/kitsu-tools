#
# Used for broadcasting "actions" -- which results in the creation of stories
# and notifications.
#

class Action
  def self.broadcast(data)
    if data[:action_type] == "created_profile_comment"
      # Create the story and substory for this action, 
      # TODO: generate notifications
      # and return the story.
      #
      # Example of data for this action type:
      #
      # {
      #   action_type: "profile_comment",
      #   user: <User>,
      #   poster: <User>,
      #   comment: "Nice avatar!"
      # }

      # Create the story and substory.
      story = Story.create(
        story_type: "comment",
        user: data[:user],
        target: data[:poster]
      )

      substory = Substory.create(
        user: data[:poster],
        substory_type: "comment",
        story: story,
        data: {comment: data[:comment]}
      )

      if data[:user] != data[:poster]
        unless data[:poster].ninja_banned?
          Notification.create(
            notification_type: "profile_comment",
            user: data[:user],
            source: story
          )
        end
      end

      return story
    end
  end

  def self.from_library_entry(l)
    return unless l.valid?

    if l.persisted?

      if l.episodes_watched_changed? and l.episodes_watched and l.episodes_watched - l.episodes_watched_was == 1
        service = nil
        Substory.from_action({
          user_id: l.user.id,
          action_type: "watched_episode",
          anime_id: l.anime.slug,
          episode_number: l.episodes_watched,
          service: service
        })
      end

      if l.status_changed?
        Substory.from_action({
          user_id: l.user.id,
          action_type: "watchlist_status_update",
          anime_id: l.anime.slug,
          old_status: l.status_was,
          new_status: l.status,
          time: Time.now
        })
      end

    else
      # Need to make a "added to library" status update.
      Substory.from_action({
        user_id: l.user.id,
        action_type: "watchlist_status_update",
        anime_id: l.anime.slug,
        old_status: nil,
        new_status: l.status,
        time: Time.now
      })
    end
  end
end
