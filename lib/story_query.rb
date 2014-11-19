class StoryQuery

  # Returns a list of stories having the given IDs.
  def self.find_by_ids(story_ids, current_user)
    stories = Story.where(id: story_ids).for_user(current_user)
                   .includes(:user, :substories, :target,
                             substories: [:user, :target])

    # Preload genres for anime stories.
    anime_stories = stories.select {|s| s.target_type == "Anime" }.map(&:target)
                   .index_by(&:id)
    Anime.where(id: anime_stories.values.map(&:id)).includes(:genres).each do |a|
      assoc = anime_stories[a.id].association(:genres)
      assoc.loaded!
      assoc.target.concat(a.genres)
      a.genres.each {|genre| assoc.set_inverse_instance(genre) }
    end

    # Preload user is_followed? value
    users = stories.map(&:user)
    users += stories.select {|x| x.target_type == "User" }.map(&:target)
    substories = stories.map(&:substories).flatten
    users += substories.map(&:user)
    users += substories.select {|x| x.target_type == "User" }.map(&:target)
    users = users.uniq
    if current_user
      users = users.index_by(&:id)
      User.where(id: users.keys).includes(:follower_items).each do |u|
        assoc = users[u.id].association(:follower_items)
        assoc.loaded!
        assoc.target.concat(u.follower_items)
        u.follower_items.each {|f| assoc.set_inverse_instance(f) }
      end
    else
      users.each do |user|
        assoc = user.association(:follower_items)
        assoc.loaded!
      end
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
