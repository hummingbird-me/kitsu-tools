class MoveWatchlistStatusUpdatesToNewFormat < ActiveRecord::Migration
  def up
    Story.where(story_type: "watchlist_status_update").each(&:destroy)
    Substory.where(substory_type: "watchlist_status_update").each(&:destroy)
    Watchlist.where("updated_at > :t", t: 2.weeks.ago).each {|x| story = Story.for_user_and_anime(x.user, x.anime); sub = Substory.create({user: x.user, substory_type: "watchlist_status_update", story: story, data: {old_status: nil, new_status: x.status}}); sub.created_at = sub.updated_at = x.updated_at; sub.save }
    Story.where(story_type: "media_story").each {|story| story.update_column('updated_at', story.substories.map {|x| x.created_at }.max) }
  end

  def down
  end
end
