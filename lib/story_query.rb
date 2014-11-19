class StoryQuery

  # Returns a list of stories having the given IDs.
  def self.find_by_ids(story_ids, current_user)
    stories = Story.where(id: story_ids).for_user(current_user)
                   .includes(:user, :substories, :target, substories: :user)

    # Preload genres for anime stories.
    anime_stories = stories.select {|s| s.target_type == "Anime" }.map(&:target)
                   .index_by(&:id)
    Anime.where(id: anime_stories.values.map(&:id)).includes(:genres).each do |a|
      assoc = anime_stories[a.id].association(:genres)
      assoc.loaded!
      assoc.target.concat(a.genres)
      a.genres.each {|genre| assoc.set_inverse_instance(genre) }
    end

    stories.sort_by {|s| story_ids.find_index s.id }
  end

  # Return `limit` stories for the given user.
  def self.find_for_user(user, current_user, page, per_page)
    story_ids = user.stories.for_user(current_user)
                    .order('stories.updated_at DESC').select(:id)
                    .page(page).per(per_page).map(&:id)

    StoryQuery.find_by_ids(story_ids, current_user)
  end

end
