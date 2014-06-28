# == Schema Information
#
# Table name: votes
#
#  id          :integer          not null, primary key
#  target_id   :integer          not null
#  target_type :string(255)      not null
#  user_id     :integer          not null
#  positive    :boolean          default(TRUE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Vote < ActiveRecord::Base
  belongs_to :target, polymorphic: true
  belongs_to :user

  validate :check_target_accepts_negative
  def check_target_accepts_negative
    unless self.positive? or self.target.respond_to?(:total_votes)
      errors.add(:positive, "must be true")
    end
  end

  def self.for(user, target)
    Vote.where(user_id: user.id, target_id: target.id, target_type: target.class.name).first
  end

  def increment_target(key)
    if self.target.respond_to? key.to_sym
      self.target_type.constantize.increment_counter key.to_s, self.target_id
    end
  end

  def decrement_target(key)
    if self.target.respond_to? key.to_sym
      self.target_type.constantize.decrement_counter key.to_s, self.target_id
    end
  end

  after_create do
    self.increment_target(:total_votes)
    self.increment_target(:positive_votes) if self.positive?
  end

  after_destroy do
    self.decrement_target(:total_votes)
    self.decrement_target(:positive_votes) if self.positive?
  end

  before_save do
    if self.persisted? and self.positive_changed?
      if self.positive and !self.positive_was
        self.increment_target(:positive_votes)
      elsif !self.positive and self.positive_was
        self.decrement_target(:positive_votes)
      end
    end
  end
end
