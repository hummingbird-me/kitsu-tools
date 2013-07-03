class AddNinjaBannedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ninja_banned, :boolean, default: false
  end
end
