class RenameFollowedCount < ActiveRecord::Migration
  def change
    rename_column :users, :followers_count, :followers_count_hack
  end
end
