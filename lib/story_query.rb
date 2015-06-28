require_dependency 'user_query'

class StoryQuery
  # Returns a list of stories having the given IDs.
  def self.find_by_ids(story_ids, current_user)
    stories = Story.where(id: story_ids)
              .for_user(current_user)
              .preload(:target, substories: %i(target))
              .includes(:user, :substories,
                        substories: %i(user))
    stories = stories.unbanned unless current_user && current_user.ninja_banned?

    comment_stories = stories.select { |x| x.story_type == 'comment' }
    comment_index = comment_stories.index_by(&:id)

    # Load is_liked for comment stories.
    if current_user
      Vote.where(
        user_id: current_user.id,
        target_type: 'Story',
        target_id: comment_index.keys
      ).select(:target_id).each do |vote|
        comment_index[vote.target_id].set_is_liked! true
      end
    end
    comment_stories.select { |x| x.is_liked.nil? }.each do |story|
      story.set_is_liked! false
    end

    # Load recent likers for comment stories.
    sql = ActiveRecord::Base.send(:sanitize_sql_array, [
      "SELECT a.id AS story_id, d.user_id AS user_id
       FROM stories a
       JOIN
         (
           SELECT id, user_id, target_id
           FROM votes b
           WHERE id IN (
             SELECT id
             FROM votes c
             WHERE c.target_id = b.target_id
             ORDER BY created_at DESC
             LIMIT 4
           )
           AND target_type = 'Story'
         ) d
       ON (a.id=d.target_id)
       WHERE a.id IN (?)", comment_stories.map(&:id)
    ])
    recent_likers = ActiveRecord::Base.connection.execute(sql)
    recent_users = User.where(id: recent_likers.map { |x| x['user_id'].to_i })
                   .index_by(&:id)
    recent_likers.each do |x|
      comment = comment_index[x['story_id'].to_i]
      comment.recent_likers ||= []
      comment.recent_likers << recent_users[x['user_id'].to_i]
    end

    # Preload user is_followed? value
    users = stories.map(&:user)
    users += stories.select { |x| x.target_type == 'User' }.map(&:target)
    substories = stories.map(&:substories).flatten
    users += substories.map(&:user)
    users += substories.select { |x| x.target_type == 'User' }.map(&:target)
    users += recent_users.values
    users = users.uniq.compact
    UserQuery.load_is_followed(users, current_user)

    # Return stories in the same order as the IDs.
    stories.sort_by { |s| story_ids.find_index s.id }
  end

  # Find the story having a particular ID.
  def self.find_by_id(story_id, current_user)
    StoryQuery.find_by_ids([story_id], current_user).first ||
      fail(ActiveRecord::RecordNotFound)
  end

  # Return `limit` stories for the given user.
  def self.find_for_user(user, current_user, page, per_page)
    story_ids = user.stories.for_user(current_user)
                .where('stories.group_id IS NULL')
                .order('stories.updated_at DESC')
                .select(:id)
                .page(page)
                .per(per_page)
                .map(&:id)

    StoryQuery.find_by_ids(story_ids, current_user)
  end

  # Return `limit` stories for the given group.
  def self.find_for_group(group, current_user, page, per_page)
    story_ids = group.stories
                .for_user(current_user)
                .order('stories.updated_at DESC')
                .select(:id)
                .page(page)
                .per(per_page)
                .map(&:id)

    StoryQuery.find_by_ids(story_ids, current_user)
  end

  # Return popular stories.
  def self.find_popular(current_user, page, per_page)
    story_ids = Story.where('created_at > ?', 24.hours.ago)
                .order('total_votes DESC')
                .page(page)
                .per(per_page)
                .select(:id)
                .map(&:id)

    StoryQuery.find_by_ids(story_ids, current_user)
  end

  def self.find_for_landing
    story_ids = Story.where(target_type: 'User')
                .where('target_id = user_id')
                .where('group_id IS NULL')
                .order('created_at DESC')
                .limit(6)
                .select(:id).map(&:id)

    StoryQuery.find_by_ids(story_ids, nil)
  end
end
