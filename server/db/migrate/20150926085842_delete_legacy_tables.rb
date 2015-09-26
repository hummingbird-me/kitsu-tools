class DeleteLegacyTables < ActiveRecord::Migration
  def change
    # Replace with OAuth shit or rebuild separate from OAuth
    # Currently is mixing concerns
    drop_table :apps

    # Move to archive server, no longer used
    drop_table :stories
    drop_table :substories
    drop_table :forem_categories
    drop_table :forem_forums
    drop_table :forem_groups
    drop_table :forem_memberships
    drop_table :forem_moderator_groups
    drop_table :forem_posts
    drop_table :forem_subscriptions
    drop_table :forem_topics
    drop_table :forem_views
    drop_table :list_items
    drop_table :lists
  end
end
