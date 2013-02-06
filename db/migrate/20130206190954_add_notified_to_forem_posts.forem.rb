# This migration comes from forem (originally 20120228202859)
class AddNotifiedToForemPosts < ActiveRecord::Migration
  def change
    add_column :forem_posts, :notified, :boolean, :default => false
  end
end
