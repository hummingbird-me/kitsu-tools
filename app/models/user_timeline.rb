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
# * [ ] Last story update time for all users, in a sorted set.
# * [ ] Last timeline update time for all active users.
# * [ ] Set of followed users, for every user.
#
# How it should works:
#
# 1. Timelines for all active users are cached in Redis.
# 2. Each cached timeline will hold a maximum of CACHE_SIZE stories.
# 3. When the timeline is fetched, if it is more than UPDATE_FREQ seconds old, 
#    update it.
# 4. Updating the timeline involves finding the last CACHE_SIZE active users 
#
# Current Implementation Status:
#
#   Nothing to see here. >_<

class UserTimeline
  
  # Return the feed of a given user, serialized as JSON.
  #
  # Parameters:
  # * user: compulsory, the user whose timeline needs to be fetched.
  # * options: optional. If options[:page] is set, then that page of results is
  #            fetched. Otherwise, the first page is returned. Each page consists
  #            of 20 stories.
  # 
  def self.fetch(user, options={})
    page = options[:page] || 1
    ability = Ability.new user
    stories = Story.accessible_by(ability).order('updated_at DESC').where(user_id: user.following.map {|x| x.id } + [user.id]).page(page).includes(:substories).per(20)
    Entities::Story.represent(stories, current_ability: ability, title_language_preference: user.title_language_preference).to_json
  end
end
