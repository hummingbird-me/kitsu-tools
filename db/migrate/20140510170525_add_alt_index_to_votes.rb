class AddAltIndexToVotes < ActiveRecord::Migration
  def change
    add_index :votes, [:user_id, :target_type]
  end
end
