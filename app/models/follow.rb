class Follow < ActiveRecord::Base
  belongs_to :followed, class_name: 'User', counter_cache: 'followers_count_hack'
  belongs_to :follower, class_name: 'User', counter_cache: 'following_count'

  validates :follower_id, uniqueness: {scope: :followed_id}

  validate :cant_follow_self
  def cant_follow_self
    if follower_id == followed_id
      errors.add(:base, 'You cannot follow yourself')
    end
  end
end
