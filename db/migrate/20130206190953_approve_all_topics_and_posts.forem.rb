# This migration comes from forem (originally 20120228194653)
class ApproveAllTopicsAndPosts < ActiveRecord::Migration
  def up
    Forem::Topic.update_all :state => "approved"
    Forem::Post.update_all :state => "approved"
  end

  def down
  end
end

