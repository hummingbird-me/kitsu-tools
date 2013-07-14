class AddExistingFollowsToRedisCache < ActiveRecord::Migration
  def up
    Follow.find_each do |follow|
      UserTimeline.notify_follow follow.follower, follow.followed
    end
  end
  
  def down
  end
end
