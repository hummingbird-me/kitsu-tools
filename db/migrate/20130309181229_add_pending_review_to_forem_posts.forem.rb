# This migration comes from forem (originally 20120221195806)
class AddPendingReviewToForemPosts < ActiveRecord::Migration
  def change
    add_column :forem_posts, :pending_review, :boolean, :default => true

    Forem::Post.reset_column_information
    Forem::Post.update_all :pending_review => false
  end
end
