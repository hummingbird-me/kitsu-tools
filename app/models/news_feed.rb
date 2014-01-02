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

class NewsFeed
  INACTIVE_DAYS     = 30
  CACHE_SIZE        = 300
  FRESH_FETCH_SIZE  = 60

  # Redis key names and prefixes.
  FEED_PREFIX                   = "user_newsfeed:"
  USER_FOLLOWERS_PREFIX         = "user_followers:"
  USER_FOLLOWING_PREFIX         = "user_following:"
  LAST_STORY_UPDATE_TIME_KEY    = "last_story_time"
  ACTIVE_FOLLOWED_USERS_PREFIX  = "active_followed_users:"

  def initialize(user)
    @user = user
    @feed_key ||= FEED_PREFIX + @user.id.to_s
  end

  def cached?
    $redis.exists @feed_key
  end

  # Fetch a page of stories from the user's timeline. Generate a timeline if 
  # the user's timeline doesn't already exist in memory.
  def fetch(page=nil)
    regenerate_feed! unless cached?
    $redis.expire @feed_key, INACTIVE_DAYS * 24 * 60 * 60

    page ||= 1
    start_index = 20 * (page.to_i-1)
    stop_index = start_index + 20 - 1

    story_ids = $redis.zrevrange @feed_key, start_index, stop_index
    story_id_to_story = {}
    Story.where(id: story_ids).for_user(@user).includes(:substories, :user, :target).each do |story|
      story_id_to_story[story.id] = story
    end
    stories = story_ids.map {|x| story_id_to_story[x.to_i] }.compact

    Entities::Story.represent(stories, current_user: @user, title_language_preference: @user.title_language_preference).to_json
  end

  # Regenerate the user's feed from scratch.
  def regenerate_feed!
    ability = Ability.new @user
    user_set = active_followed_users + [@user.id]

    stories = Story.for_user(@user).order('updated_at DESC').where(user_id: user_set).includes(:substories).limit(FRESH_FETCH_SIZE)

    stories.each {|story| add! story }
  end

  # Add a story to the user's news feed.
  def add!(story)
    add_story = false
    if story.story_type == "comment" 
      if @user == story.target or @user.following.include?(story.target)
        add_story = true
      end
    else
      add_story = true
    end
    if add_story
      $redis.zadd @feed_key, story.updated_at.to_i, story.id
      $redis.zremrangebyrank(@feed_key, 0, -CACHE_SIZE) if rand < 0.2
    end
  end

  # Return the set of active user IDs followed by our user, who were most 
  # recently active. Limited to FRESH_FETCH_SIZE users. 
  def active_followed_users
    return @active_followed_users if @active_follower_users

    active_followed_users_key = ACTIVE_FOLLOWED_USERS_PREFIX + @user.id.to_s
    following_key = USER_FOLLOWING_PREFIX + @user.id.to_s

    $redis.zinterstore active_followed_users_key, [LAST_STORY_UPDATE_TIME_KEY, following_key], aggregate: "max"

    active_ids = $redis.zrevrange active_followed_users_key, 0, FRESH_FETCH_SIZE-1
    $redis.del active_followed_users_key

    @active_followed_users = active_ids
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
end
