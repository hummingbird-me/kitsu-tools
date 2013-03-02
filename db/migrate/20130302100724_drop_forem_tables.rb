class DropForemTables < ActiveRecord::Migration
  def up
    drop_table :forem_categories
    drop_table :forem_forums
    drop_table :forem_groups
    drop_table :forem_memberships
    drop_table :forem_moderator_groups
    drop_table :forem_posts
    drop_table :forem_subscriptions
    drop_table :forem_topics
    drop_table :forem_views
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
