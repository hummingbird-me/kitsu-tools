# This migration comes from forem (originally 20120227195911)
class RemovePendingReviewAddStateToForemPosts < ActiveRecord::Migration
  def change
    remove_column :forem_posts, :pending_review
    add_column :forem_posts, :state, :string, :default => 'pending_review'
    add_index :forem_posts, :state
  end
end
