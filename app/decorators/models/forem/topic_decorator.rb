Forem::Topic.class_eval do
  attr_accessible :forum_id, :locked, :pinned, :hidden
end
