class StoryFanoutWorker
  include Sidekiq::Worker
  sidekiq_options queue: :storyfanout

  def perform(user_id, story_id)
    story = Story.find_by_id(story_id)
    user = User.find(user_id)
    return if story.nil?

    if story.group_id
      followers = User.where(id: [user_id, story.user_id] + story.group.members.accepted.map(&:user_id))
      followers = followers.uniq
    else
      followers = User.where(id: [user_id, story.user_id]) + story.user.followers
      followers = followers.uniq
    end
    # Only ninja_banned users can see posts by ninja_banned users
    followers = followers.select { |u| u.ninja_banned? } if user.ninja_banned?

    followers.each do |follower|
      feed = NewsFeed.new(follower)
      feed.add!(story) if feed.cached?
    end
  end
end
