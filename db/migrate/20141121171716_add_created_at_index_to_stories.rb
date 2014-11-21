class AddCreatedAtIndexToStories < ActiveRecord::Migration
  def change
    add_index :stories, :created_at
  end
end
