class AddUniqueIndexToFollowsTable < ActiveRecord::Migration
  def change
    user_ids = []
    Follow.all.group_by {|x| [x.follower_id, x.followed_id].map(&:to_s).join(':') }.values.select {|x| x.length > 1 }.each do |dups|
      first = dups.shift
      dups.each do |x|
        user_ids << x.follower_id << x.followed_id
        x.delete
      end
    end
    User.where(id: user_ids).each do |user|
      user.followers_count_hack = user.followers.length
      user.following_count = user.following.length
    end

    add_index :follows, [:followed_id, :follower_id], unique: true
  end
end
