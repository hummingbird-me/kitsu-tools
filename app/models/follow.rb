class Follow < ActiveRecord::Base
  belongs_to :followed, class_name: 'User'
  belongs_to :follower, class_name: 'User'

  validates :user_id, uniqueness: {scope: :followed_id}

  validate :cant_follow_self
  def cant_follow_self
    if user_id == followed_id
      errors.add(:base, 'You cannot follow yourself')
    end
  end
  
  after_create do
    User.increment_counter 'following_count', follower_id
    User.increment_counter 'followers_count', followed_id
  end
  
  after_destroy do
    User.decrement_counter 'following_count', follower_id
    User.decrement_counter 'followers_count', followed_id
  end
end
