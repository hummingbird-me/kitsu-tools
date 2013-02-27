class RemoveAnimeAndUserFromEpisodeView < ActiveRecord::Migration
  def up
    remove_column :episode_views, :anime_id
    remove_column :episode_views, :user_id
  end

  def down
    add_column :episode_views, :user_id, :integer
    add_column :episode_views, :anime_id, :integer
  end
end
