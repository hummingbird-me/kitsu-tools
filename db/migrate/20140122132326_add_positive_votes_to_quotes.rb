class AddPositiveVotesToQuotes < ActiveRecord::Migration
  def change
    add_column :quotes, :positive_votes, :integer, default: 0, null: false
  end
end
