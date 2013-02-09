class TopicsAndPostsNowApprovedByDefault < ActiveRecord::Migration
  def up
    change_column_default(:forem_topics, :state, 'approved')
    change_column_default(:forem_posts, :state, 'approved')
    change_column_default(:users, :forem_state, 'approved')
  end

  def down
    change_column_default(:forem_topics, :state, 'pending_review')
    change_column_default(:forem_posts, :state, 'pending_review')
    change_column_default(:users, :forem_state, 'pending_review')
  end
end
