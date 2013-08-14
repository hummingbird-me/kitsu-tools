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
        Notification.create(
          notification_type: "profile_comment",
          user: data[:user],
          source: story
        )
      end

      return story
    end
  end
end
