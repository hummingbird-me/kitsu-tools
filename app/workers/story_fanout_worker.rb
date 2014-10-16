class StoryFanoutWorker
  include Sidekiq::Worker

  def perform(user_id, story_id)
    story = Story.find_by_id story_id
    return if story.nil?

    followers = User.where(id: [user_id, story.user_id]) + story.user.followers
    followers = followers.uniq

    story_json = StorySerializer.new(story).as_json

    followers.each do |follower|
      feed = NewsFeed.new(follower)
      feed.add!(story) if feed.cached?
      follower.private_publish "/newsfeed", story_json
    end
  end
end
