# == Schema Information
#
# Table name: notifications
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  source_id         :integer
#  source_type       :string(255)
#  data              :hstore
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  notification_type :string(255)
#  seen              :boolean          default(FALSE)
#

class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :source, polymorphic: true

  def source_user
    if notification_type == "profile_comment"
      source.target
    elsif notification_type == "comment_reply"
      source.user
    end
  end

  def image
    source_user.avatar.url(:thumb_small)
  end

  def self.unseen_count(user_id)
    user_id = user_id.id unless user_id.is_a? Fixnum
    #Rails.cache.fetch(:"#{user_id}_unseen_notifications", expires_in: 60.minutes) do
    Notification.where(user_id: user_id, seen: false).count
    #end
  end

  def self.recent_notifications(user_id)
    user_id = user_id.id unless user_id.is_a? Fixnum
    #Rails.cache.fetch(:"#{user_id}_recent_notifications", expires_in: 60.minutes) do
    Notification.where(user_id: user_id).order('CASE WHEN seen THEN 1 ELSE 0 END, created_at DESC').limit(3).dup
    #end
  end

  def self.uncache_notification_cache(user_id)
    user_id = user_id.id unless user_id.is_a? Fixnum
    #Rails.cache.delete(:"#{user_id}_unseen_notifications")
    #Rails.cache.delete(:"#{user_id}_recent_notifications")
  end

  after_create do
    Notification.uncache_notification_cache(self.user_id)
    #MessageBus.publish "/notifications", NotificationSerializer.new(self).as_json.as_json, user_ids: [self.user_id]
  end
end
