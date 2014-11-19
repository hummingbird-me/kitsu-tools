require_dependency 'user_query'

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
    UserQuery.load_is_followed(users, current_user)

    # Load is_liked for comment stories.
    comment_stories = stories.select {|x| x.story_type == "comment" }
    if current_user
      comment_index = comment_stories.index_by(&:id)
      Vote.where(user_id: current_user.id, target_type: "Story",
                 target_id: comment_index.keys).select(:target_id).each do |vote|
        comment_index[vote.target_id].set_is_liked! true
      end
    end
    comment_stories.select {|x| x.is_liked.nil? }.each do |story|
      story.set_is_liked! false
    end

    # Return stories in the same order as the IDs.
    stories.sort_by {|s| story_ids.find_index s.id }
  end

  # Find the story having a particular ID.
  def self.find_by_id(story_id, current_user)
    StoryQuery.find_by_ids([story_id], current_user).first || raise(ActiveRecord::RecordNotFound)
  end

  # Return `limit` stories for the given user.
  def self.find_for_user(user, current_user, page, per_page)
    story_ids = user.stories.for_user(current_user)
                    .order('stories.updated_at DESC').select(:id)
                    .page(page).per(per_page).map(&:id)

    StoryQuery.find_by_ids(story_ids, current_user)
  end

end
