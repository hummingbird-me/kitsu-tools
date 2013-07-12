# Implementation of the timeline shown on user homepages.
#
# Definitions:
#
# * For the purposes of the user timeline, an active user is defined as a user 
#   who has generated a story in the last INACTIVE_DAYS days.
#
# Parameters:
# * INACTIVE_DAYS: Number of days before a user is considered to be inactive.
# * CACHE_SIZE: Number of stories shown in a user's timeline.
# * UPDATE_FREQ: For how much time is a cached timeline considered active.
#
# What needs to be stored in Redis for the timelines:
#
# * Last story update time for all users.
# * Last timeline update time for all active users.
# * Set of followed users, for every user.
#
# How it should works:
#
# 1. Timelines for all active users are cached in Redis.
# 2. Each cached timeline will hold a maximum of CACHE_SIZE stories.
# 3. When the timeline is fetched, if it is more than UPDATE_FREQ seconds old, 
#    update it.
# 4. Updating the timeline involves finding the last CACHE_SIZE active users 
#

class UserTimeline
  INACTIVE_DAYS = 10
  CACHE_SIZE    = 200
  UPDATE_FREQ   = 30
  
  # Redis key names and prefixes.
  LAST_STORY_UPDATE_TIME_KEY    = "last_story_time"
  LAST_TIMELINE_UPDATE_TIME_KEY = "last_timeline_update"
  USER_FOLLOWERS_PREFIX         = "user_followers:"
  USER_FOLLOWING_PREFIX         = "user_following:"
  ACTIVE_FOLLOWED_USERS_PREFIX  = "active_followed_users:"
  TIMELINE_CACHE_PREFIX         = "user_timeline:"
  
  #
  # Return the feed of a given user, serialized as JSON.
  #
  # Parameters:
  # * user:     the user whose timeline needs to be fetched.
  # * options:  (optional) If options[:page] is set, then that page of results 
  #             is fetched. Otherwise, the first page is returned. Each page 
  #             consists of 20 stories.
  # 
  def self.fetch(user, options={})
    page = (options[:page] || 1).to_i
    ability = Ability.new user
    
    story_cache_key = TIMELINE_CACHE_PREFIX + user.id.to_s

    stories = $redis.get story_cache_key
    if stories
      stories = JSON.parse stories
    else
      new_stories = UserTimeline.get_new_stories(user)
      stories = Entities::Story.represent(new_stories, current_ability: ability, title_language_preference: user.title_language_preference)
    end
    # TODO Update if needed.
    $redis.set story_cache_key, stories.to_json
    $redis.expire story_cache_key, 30 # INACTIVE_DAYS * 24 * 60 * 60
    
    start_index = 20 * (page-1)
    stop_index = start_index + 20 - 1
    return stories[start_index..stop_index].to_json
  end
  
  #
  # Aggregate an array of `new_stories` into a given `cached_timeline` and
  # return the new timeline.
  #
  # Parameters:
  # * cached_timeline: The current timeline cached for the given user. Already
  #                    in the entity representation.
  # * new_stories: Array of new stories to be merged with the cached timeline.
  #
  def self.aggregate_stories(cached_timeline, new_stories)
    # TODO: Implement this.
    cached_timeline
  end
  
  #
  # Get all new stories to consider adding to the current user's timeline. 
  #
  # Parameters:
  # * user: The user we are fetching stories for.
  # * time: (optional) The time after which we need to look for stories. If 
  #         this is not set, it means the user's timeline has expired from the 
  #         cache and we are generating a new one from scratch.
  #
  def self.get_new_stories(user, time=nil)
    ability = Ability.new user
    user_set = UserTimeline.get_active_followed_users(user, time) + [user.id]
    stories = Story.accessible_by(ability).order('updated_at DESC').where(user_id: user_set).includes(:substories).limit(CACHE_SIZE)
    if time
      stories = stories.where('updated_at >= ?', time)
    end
    stories
  end
  
  # 
  # Return a list of user IDs corresponding to users who follow the given user
  # and had a story updated after the given time. Limited to CACHE_SIZE users.
  #
  # Parameters:
  # * user: The user in question.
  # * time: (optional) If this is set, only return users with story updates
  #         after the specified time.
  #
  def self.get_active_followed_users(user, time=nil)
    active_followed_users_key = ACTIVE_FOLLOWED_USERS_PREFIX + user.id.to_s
    following_key = USER_FOLLOWING_PREFIX + user.id.to_s
    $redis.zinterstore active_followed_users_key, [LAST_STORY_UPDATE_TIME_KEY, following_key], aggregate: "max"

    if time
      active_ids = $redis.zrevrangebyscore active_followed_users_key, Time.now.to_i + 10, time.to_i
    else
      active_ids = $redis.zrevrange active_followed_users_key, 0, CACHE_SIZE
    end
    
    active_ids = active_ids[0...CACHE_SIZE] if active_ids.length > CACHE_SIZE

    active_ids
  end
  
  #
  # Called when a story is generated for a particular user. Save this time to a
  # Sorted Set stored in Redis.
  #
  # Parameters:
  # * user: User for whom the story was generated.
  # * time: (optional) Time of the update. Defaults to Time.now if it is not
  #         provided.
  #
  def self.notify_story_updated(user, time=nil)
    time ||= Time.now
    $redis.zadd LAST_STORY_UPDATE_TIME_KEY, time.to_i, user.id
  end
  
  #
  # Called when a user follows another user. It is cached to two Redis sets: 
  # one for the list of users followed by the current user, and the list of 
  # followers of the followed user.
  #
  # Parameters:
  # * user: The user who performs the follow action.
  # * followed: The user who was followed.
  #
  def self.notify_follow(user, followed)
    followers_key = USER_FOLLOWERS_PREFIX + followed.id.to_s
    following_key = USER_FOLLOWING_PREFIX + user.id.to_s
    $redis.sadd followers_key, user.id
    $redis.sadd following_key, followed.id
  end

  #
  # Called when a user unfollows another. Removes the cached items added by
  # `notify_follow`.
  #
  # Parameters:
  # * user: The user who performs the unfollow action.
  # * followed: The user who was unfollowed.
  #
  def self.notify_unfollow(user, followed)
    followers_key = USER_FOLLOWERS_PREFIX + followed.id.to_s
    following_key = USER_FOLLOWING_PREFIX + user.id.to_s
    $redis.srem followers_key, user.id
    $redis.srem following_key, followed.id
  end
end
