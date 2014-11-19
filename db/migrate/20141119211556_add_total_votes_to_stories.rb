class AddTotalVotesToStories < ActiveRecord::Migration
  def change
    add_column :stories, :total_votes, :integer, null: false, default: 0
  end
end
