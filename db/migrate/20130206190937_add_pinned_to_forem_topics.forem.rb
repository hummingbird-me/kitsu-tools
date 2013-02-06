# This migration comes from forem (originally 20110519222000)
class AddPinnedToForemTopics < ActiveRecord::Migration
  def change
    add_column :forem_topics, :pinned, :boolean, :default => false, :nullable => false
  end
end
