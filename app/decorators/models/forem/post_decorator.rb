Forem::Post.class_eval do
  searchable do
    integer :topic_id
    text(:topic_subject) {|post| post.topic.subject }
    text :text
  end

  def set_topic_last_post_at
    topic.update_attribute(:last_post_at, created_at) unless self.user.ninja_banned?
  end
end
