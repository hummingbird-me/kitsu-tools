class StoryFactory
  def self.status_change_story(user_id, anime_slug, old_status, new_status)
    Substory.from_action({
      user_id: user_id,
      action_type: "watchlist_status_update",
      anime_id: anime_slug,
      old_status: old_status,
      new_status: new_status,
      time: Time.now
    })
  end
end
