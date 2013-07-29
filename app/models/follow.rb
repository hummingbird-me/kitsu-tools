class Follow < ActiveRecord::Base
  belongs_to :followed, class_name: 'User'
  belongs_to :follower, class_name: 'User'

  validates :follower_id, uniqueness: {scope: :followed_id}

  validate :cant_follow_self
  def cant_follow_self
    if follower_id == followed_id
      errors.add(:base, 'You cannot follow yourself')
    end
  end

  after_create do
    User.increment_counter 'following_count', self.follower_id
    User.increment_counter 'followers_count_hack', self.followed_id
    NewsFeed.notify_follow self.follower, self.followed
  end

  before_destroy do
    User.decrement_counter 'following_count', self.follower_id
    User.decrement_counter 'followers_count_hack', self.followed_id
    NewsFeed.notify_unfollow self.follower, self.followed
  end
end
