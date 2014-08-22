class RemoveBrokenUniqueConstraintOnVideos < ActiveRecord::Migration
  def change
    remove_index :videos, [:episode_id, :streamer_id]
  end
end
