# == Schema Information
#
# Table name: follows
#
#  id          :integer          not null, primary key
#  followed_id :integer
#  follower_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

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
  end

  before_destroy do
    User.decrement_counter 'following_count', self.follower_id
    User.decrement_counter 'followers_count_hack', self.followed_id
  end
end
