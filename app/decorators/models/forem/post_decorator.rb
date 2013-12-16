Forem::Post.class_eval do
  def set_topic_last_post_at
    topic.update_attribute(:last_post_at, created_at) if topic.last_post_at.nil? or !self.user.ninja_banned?
  end
end
