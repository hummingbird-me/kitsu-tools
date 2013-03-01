class DropEpisodeViews < ActiveRecord::Migration
  def change
    drop_table :episode_views
  end
end
