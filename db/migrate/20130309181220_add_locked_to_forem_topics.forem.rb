# This migration comes from forem (originally 20110519210300)
class AddLockedToForemTopics < ActiveRecord::Migration
  def change
    add_column :forem_topics, :locked, :boolean, :null => false, :default => false
  end
end
