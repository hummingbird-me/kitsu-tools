# This migration comes from forem (originally 20120222000227)
class AddForemTopicsLastPostAt < ActiveRecord::Migration
  def up
    add_column :forem_topics, :last_post_at, :datetime
    Forem::Topic.reset_column_information
    Forem::Topic.includes(:posts).find_each do |t|
      post = t.posts.last
      t.update_attribute(:last_post_at, post.updated_at)
    end
  end

  def down
    drop_column :forem_topics, :last_post_at
  end
end
