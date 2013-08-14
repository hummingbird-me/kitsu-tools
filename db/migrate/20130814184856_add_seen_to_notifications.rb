class AddSeenToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :seen, :boolean, default: false
  end
end
