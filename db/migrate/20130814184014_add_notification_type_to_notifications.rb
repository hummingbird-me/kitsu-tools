class AddNotificationTypeToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :notification_type, :string
  end
end
