# This migration comes from forem (originally 20120302152918)
class AddForemViewFields < ActiveRecord::Migration
  def up
    add_column :forem_views, :current_viewed_at, :datetime
    add_column :forem_views, :past_viewed_at, :datetime
    add_column :forem_topics, :views_count, :integer, :default=>0
    add_column :forem_forums, :views_count, :integer, :default=>0

    Forem::Topic.find_each do |topic|
      topic.update_column(:views_count, topic.views.sum(:count))
    end

    Forem::Forum.find_each do |forum|
      forum.update_column(:views_count, forum.topics.sum(:views_count))
    end
  end

  def down
    remove_column :forem_views, :current_viewed_at
    remove_column :forem_views, :past_viewed_at
    remove_column :forem_topics, :views_count
    remove_column :forem_forums, :views_count
  end
end
