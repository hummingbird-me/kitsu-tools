class UserCountShouldBeAnInteger < ActiveRecord::Migration
  def change
    change_column :anime, :user_count, :integer, default: 0, null: false
  end
end
