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
      Story.transaction do
        rs = user.stories.where(story_type: 'followed').order("updated_at DESC").limit(1)
        if rs.length == 1 and rs[0].updated_at >= 6.hours.ago
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
      end
    end
  end
end
