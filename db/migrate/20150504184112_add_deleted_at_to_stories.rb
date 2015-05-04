class AddDeletedAtToStories < ActiveRecord::Migration
  def change
    # Stories
    add_column :stories, :deleted_at, :datetime
    add_index :stories, :deleted_at

    # Substories
    add_column :substories, :deleted_at, :datetime
    add_index :substories, :deleted_at
  end
end
