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
# * FRESH_FETCH_SIZE: How many stories to fetch when generating from scratch.
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
#

class UserTimeline
  INACTIVE_DAYS     = 10
  CACHE_SIZE        = 200
  FRESH_FETCH_SIZE  = 50
  
  # Redis key names and prefixes.
  LAST_STORY_UPDATE_TIME_KEY    = "last_story_time"
  LAST_TIMELINE_UPDATE_TIME_KEY = "last_timeline_update"
  USER_FOLLOWERS_PREFIX         = "user_followers:"
  USER_FOLLOWING_PREFIX         = "user_following:"
  ACTIVE_FOLLOWED_USERS_PREFIX  = "active_followed_users:"
  TIMELINE_CACHE_PREFIX         = "user_timeline:"
  TIMELINE_LOCK_PREFIX              = "timeline_lock:"
  
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
    timeline_cache_key = TIMELINE_CACHE_PREFIX + user.id.to_s
    
    unless $redis.exists timeline_cache_key
      UserTimeline.regenerate_timeline!(user)
    end
    
    timeline = $redis.get timeline_cache_key
    timeline = JSON.parse timeline
    
    $redis.expire timeline_cache_key, INACTIVE_DAYS * 24 * 60 * 60
    
    page    = (options[:page] || 1).to_i
    start_index = 20 * (page-1)
    stop_index = start_index + 20 - 1
    stop_index = -1 if stop_index > timeline.length-1

    if start_index < timeline.length
      timeline[start_index..stop_index].to_json
    else
      [].to_json
    end
  end
  
  # 
  # Generate the given user's timeline from scratch, after it has expired.
  #
  # Parameters:
  # * user: The user whose timeline is to be generated.
  #
  def self.regenerate_timeline!(user)
    timeline_cache_key = TIMELINE_CACHE_PREFIX + user.id.to_s
    ability = Ability.new user
    
    # Get the set of active followed users.
    user_set = UserTimeline.get_active_followed_users(user)
    if user_set.length > FRESH_FETCH_SIZE
      user_set = user_set[0...FRESH_FETCH_SIZE] 
    end
    user_set += [user.id]
    
    # Get the list of stories.
    stories = Story.accessible_by(ability).order('updated_at DESC').where(user_id: user_set).includes(:substories).limit(FRESH_FETCH_SIZE)
    stories = JSON.parse Entities::Story.represent(stories, current_ability: ability, title_language_preference: user.title_language_preference).to_json
    
    # Save the stories as the user's timeline.
    timeline = UserTimeline.aggregate([], stories)
    UserTimeline.update_user_timeline! user, timeline
  end
  
  #
  # Update a user's timeline to a new one.
  #
  # Parameters:
  # * user: The user whose timeline is to be set.
  # * timeline: Entity representation of the timeline to be saved.
  #
  def self.update_user_timeline!(user, timeline)
    timeline_cache_key = TIMELINE_CACHE_PREFIX + user.id.to_s
    $redis.set timeline_cache_key, timeline.to_json
    $redis.zadd LAST_TIMELINE_UPDATE_TIME_KEY, Time.now.to_i, user.id
  end
  
  
  #
  # Aggregate an array of `new_stories` into a given `cached_timeline` and
  # return the new timeline.
  #
  # Parameters:
  # * cached_timeline: The current timeline cached for the given user. Already
  #                    in the entity representation.
  # * new_stories: New stories to be merged with the cached timeline.
  #
  def self.aggregate(cached_timeline, new_stories)
    # Step 1. Convert the cached_timeline array into a (story id -> story) map.
    story_map = {}
    cached_timeline.each do |story|
      story_map[story["id"]] = story
    end
    
    # Step 2. Insert the new stories into the map.
    new_stories.each do |story|
      story_map[story["id"]] = story
    end

    # Step 3. Sort all of the stories into an array by update time.
    new_timeline = []
    story_map.each do |story_id, story|
      new_timeline.push story
    end
    new_timeline.sort_by! {|s| s["updated_at"] }
    new_timeline.reverse!
    
    # Step 4. Filter out stories that aren't relevant.
    # * Remove all stories that no longer exist.
    new_timeline = new_timeline.select {|s| Story.exists? s["id"] }
    
    # Step 5. Take the top CACHE_SIZE stories.
    new_timeline = new_timeline[0...CACHE_SIZE] if new_timeline.length > CACHE_SIZE
    
    # Step 6. Return the new timeline.
    new_timeline
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
    
    $redis.del active_followed_users_key
    
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
  
  #
  # Acquire a lock on a user's timeline.
  #
  def self.acquire_lock(user)
    lock_key = TIMELINE_LOCK_PREFIX + user.id.to_s
    until $redis.setnx(lock_key, "locked")
      sleep 1
    end
    $redis.expire lock_key, 5
  end
  
  #
  # Release lock on a user's timeline.
  #
  def self.release_lock(user)
    lock_key = TIMELINE_LOCK_PREFIX + user.id.to_s
    $redis.del lock_key
  end
end
