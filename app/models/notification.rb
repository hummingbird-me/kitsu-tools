class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :source, polymorphic: true
  attr_accessible :user, :source, :data, :notification_type
  serialize :data, ActiveRecord::Coders::Hstore

  def self.unseen_count(user_id)
    user_id = user_id.id unless user_id.is_a? Fixnum
    Rails.cache.fetch(:"#{user_id}_unseen_notifications", expires_in: 60.minutes) do
      Notification.where(user_id: user_id, seen: false).count
    end
  end

  def self.uncache_notification_count(user_id)
    user_id = user.id unless user_id.is_a? Fixnum
    Rails.cache.delete(:"#{user_id}_unseen_notifications")
  end

  after_create do
    Notification.uncache_notification_count(self.user_id)
  end
end
