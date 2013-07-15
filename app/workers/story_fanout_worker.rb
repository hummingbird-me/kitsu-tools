class StoryFanoutWorker
  include Sidekiq::Worker

  def perform(user_id, story_id)
    followers = [user_id] + $redis.smembers(UserTimeline::USER_FOLLOWERS_PREFIX + user_id.to_s)
    story = Story.find_by_id story_id
    if story
      followers += [story.user_id]
    end
    followers = followers.uniq
    
    followers.each do |follower_id|
      if $redis.exists(UserTimeline::TIMELINE_CACHE_PREFIX + follower_id.to_s)
        follower = User.find follower_id
        UserTimeline.acquire_lock follower
        
        if story
          stories = JSON.parse Entities::Story.represent([story], current_ability: Ability.new(follower), title_language_preference: follower.title_language_preference).to_json
        else
          # Just need to re-aggregate.
          stories = []
        end
        
        timeline = UserTimeline.aggregate(JSON.parse($redis.get(UserTimeline::TIMELINE_CACHE_PREFIX + follower_id.to_s)), stories)
        UserTimeline.update_user_timeline! follower, timeline
          
        UserTimeline.release_lock follower
      end
    end
  end
end
