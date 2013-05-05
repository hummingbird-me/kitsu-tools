class FixFollowedColumnNames < ActiveRecord::Migration
  def change
    rename_column :follows, :followed_id, :follower_id
    rename_column :follows, :user_id, :followed_id
  end
end
