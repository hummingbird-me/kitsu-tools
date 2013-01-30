class AddYoutubeVideoIdToAnime < ActiveRecord::Migration
  def change
    add_column :animes, :youtube_video_id, :string
  end
end
