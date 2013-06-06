class AddWatchlistToStory < ActiveRecord::Migration
  def change
    change_table :stories do |t|
      t.references :watchlist
    end
    
    Story.where(story_type: "media_story").each {|x| x.watchlist = Watchlist.find_by_user_id_and_anime_id(x.user_id, x.target_id); x.save }
    Story.where(story_type: "media_story").each {|story| story.update_column('updated_at', story.substories.map {|x| x.created_at }.max) }
    
  end
end
