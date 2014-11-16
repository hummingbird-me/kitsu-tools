class IndexAnimeOnUserCount < ActiveRecord::Migration
  def change
    add_index :anime, :user_count
  end
end
