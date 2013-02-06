# This migration comes from forem (originally 20110228084940)
class AddReplyToToForemPosts < ActiveRecord::Migration
  def change
    add_column :forem_posts, :reply_to_id, :integer
  end
end
