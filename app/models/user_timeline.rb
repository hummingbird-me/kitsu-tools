# Implementation of the timeline shown on user homepages.
#
# Definitions:
#
# * For the purposes of the user timeline, an active user is defined as a user who
#   has generated a story in the last INACTIVE_DAYS days.
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
  
  #
  # Return the feed of a given user, serialized as JSON.
  #
  # Parameters:
  # * user:     the user whose timeline needs to be fetched.
  # * options:  (optional) If options[:page] is set, then that page of results is
  #             fetched. Otherwise, the first page is returned. Each page consists
  #             of 20 stories.
  # 
  def self.fetch(user, options={})
    page = options[:page] || 1
    ability = Ability.new user
    stories = Story.accessible_by(ability).order('updated_at DESC').where(user_id: user.following.map {|x| x.id } + [user.id]).page(page).includes(:substories).per(20)
    Entities::Story.represent(stories, current_ability: ability, title_language_preference: user.title_language_preference).to_json
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
  # Called when a user follows another user. It is cached to two Redis sets: one
  # for the list of users followed by the current user, and the list of followers
  # of the followed user.
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
