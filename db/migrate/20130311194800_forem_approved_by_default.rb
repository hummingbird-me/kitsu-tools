class ForemApprovedByDefault < ActiveRecord::Migration
  def up
    change_column :users, :forem_state, :string, :default => 'approved'
    change_column :forem_topics, :state, :string, :default => 'approved'
    change_column :forem_posts, :state, :string, :default => 'approved'
  end

  def down
    change_column :users, :forem_state, :string, :default => 'pending_review'
    change_column :forem_topics, :state, :string, :default => 'pending_review'
    change_column :forem_posts, :state, :string, :default => 'pending_review'
  end
end
