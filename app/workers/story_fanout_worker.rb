class StoryFanoutWorker
  include Sidekiq::Worker

  def perform(user_id, story_id)
    story = Story.find_by_id story_id
    return if story.nil?

    followers = User.where(id: [user_id, story.user_id]) + story.user.followers
    followers = followers.uniq

    followers.each do |follower|
      feed = NewsFeed.new(follower)
      feed.add!(story) if feed.cached?
    end
  end
end
