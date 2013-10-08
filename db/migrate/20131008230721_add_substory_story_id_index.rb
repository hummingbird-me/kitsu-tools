class AddSubstoryStoryIdIndex < ActiveRecord::Migration
  def change
    add_index(:substories, [:story_id])
  end
end
