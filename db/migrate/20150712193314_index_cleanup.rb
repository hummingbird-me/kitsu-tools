class IndexCleanup < ActiveRecord::Migration
  def change
    # Extremely common operations
    add_index :reviews, :user_id
    add_index :reviews, :anime_id
    add_index :recommendations, :user_id

    # WTF?
    remove_index :users, :waifu_or_husbando
    remove_index :users, :waifu_slug

    # Used on Kotodama only, but avoids 6-second load times
    add_index :substories, :created_at
  end
end
