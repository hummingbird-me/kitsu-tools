require_dependency 'story_query'

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
  FEED_PREFIX = "user_newsfeed:"

  def initialize(user)
    @user = user
    @feed_key ||= FEED_PREFIX + @user.id.to_s
  end

  def cached?
    $redis.with {|conn| conn.exists @feed_key }
  end

  # Fetch a page of stories from the user's timeline. Generate a timeline if
  # the user's timeline doesn't already exist in memory.
  def fetch(page=nil)
    regenerate_feed! unless cached?

    page ||= 1
    start_index = 30 * (page.to_i-1)
    stop_index = start_index + 30 - 1

    story_ids = []
    $redis.with do |conn|
      conn.expire @feed_key, INACTIVE_DAYS * 24 * 60 * 60
      story_ids = conn.zrevrange(@feed_key, start_index, stop_index).collect(&:to_i)
    end

    StoryQuery.find_by_ids(story_ids, @user)
  end

  # Regenerate the user's feed from scratch.
  def regenerate_feed!
    user_set = active_followed_users + [@user.id]
    group_set = active_joined_groups.to_a

    stories = Story.for_user(@user)
                   .order('stories.updated_at DESC')
                   .where('(stories.user_id IN (?) AND stories.group_id IS NULL) OR stories.group_id IN (?)', user_set, group_set)
                   .preload(:target)
                   .limit(FRESH_FETCH_SIZE)
    stories = stories.unbanned unless @user.ninja_banned?
    stories.each {|story| add! story }
  end

  # Add a story to the user's news feed.
  def add!(story)
    add_story = false
    if story.story_type == "comment"
      if story.group_id || @user == story.target || @user.following.include?(story.target)
        add_story = true
      end
    elsif story.story_type != "followed"
      add_story = true
    end
    if add_story
      $redis.with do |conn|
        conn.zadd @feed_key, story.updated_at.to_i, story.id
        conn.zremrangebyrank(@feed_key, 0, -CACHE_SIZE) if rand < 0.2
      end
    end
  end

  # Return the set of active user IDs followed by our user, who were most
  # recently active. Limited to FRESH_FETCH_SIZE users.
  def active_followed_users
    @user.following.limit(FRESH_FETCH_SIZE)
  end

  # Return the set of active group IDs which our user is part of, which
  # were most recently active.  Limited to FRESH_FETCH_SIZE groups.
  def active_joined_groups
    @user.groups.limit(FRESH_FETCH_SIZE)
  end
end
