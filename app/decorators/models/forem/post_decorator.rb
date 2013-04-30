Forem::Post.class_eval do
  searchable do
    integer :topic_id
    text(:topic_subject) {|post| post.topic.subject }
    text :text
  end
end
