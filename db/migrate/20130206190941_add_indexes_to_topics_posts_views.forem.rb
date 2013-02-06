# This migration comes from forem (originally 20111026143136)
class AddIndexesToTopicsPostsViews < ActiveRecord::Migration
  def change
    add_index :forem_topics, :forum_id
    add_index :forem_topics, :user_id    
    add_index :forem_posts, :topic_id
    add_index :forem_posts, :user_id    
    add_index :forem_posts, :reply_to_id    
    add_index :forem_views, :user_id
    add_index :forem_views, :topic_id    
    add_index :forem_views, :updated_at 
  end
end
