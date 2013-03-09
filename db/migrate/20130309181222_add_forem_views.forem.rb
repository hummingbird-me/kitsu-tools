# This migration comes from forem (originally 20110520150056)
class AddForemViews < ActiveRecord::Migration
  def change
    create_table :forem_views do |t|
      t.integer :user_id
      t.integer :topic_id
      t.datetime :created_at
    end
  end
end
