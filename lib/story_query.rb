class StoryQuery

  # Returns a list of stories having the given IDs.
  def self.find_by_ids(story_ids, current_user)
    # Side-load genres for stories where the target is anime.
    stories = Story.where(id: story_ids, :target_type => 'Anime').for_user(current_user).includes(:user, :substories, target: :genres, substories: :user)
    # Don't side-load genres for regular stories.
    if story_ids.length > stories.length
      stories += Story.where(id: story_ids).where('target_type <> ?', 'Anime').for_user(current_user).includes(:user, :substories, :target, substories: :user)
    end
    # Return in the same order as the IDs passed in.
    stories.sort_by {|s| story_ids.find_index s.id }
  end

  # Return `limit` stories for the given user.
  def self.find_for_user(user, current_user, page, per_page)
    story_ids = user.stories.for_user(current_user).order('stories.updated_at DESC').select(:id).page(page).per(per_page).map {|x| x.id }
    StoryQuery.find_by_ids(story_ids, current_user)
  end

end
