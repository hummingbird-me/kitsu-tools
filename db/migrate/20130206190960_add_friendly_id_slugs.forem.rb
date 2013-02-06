# This migration comes from forem (originally 20120718073130)
class AddFriendlyIdSlugs < ActiveRecord::Migration
  def change
    add_column :forem_forums, :slug, :string
    add_index :forem_forums, :slug, :unique => true
    Forem::Forum.reset_column_information
    Forem::Forum.find_each {|t| t.save! }

    add_column :forem_categories, :slug, :string
    add_index :forem_categories, :slug, :unique => true
    Forem::Category.reset_column_information
    Forem::Category.find_each {|t| t.save! }

    add_column :forem_topics, :slug, :string
    add_index :forem_topics, :slug, :unique => true
    Forem::Topic.reset_column_information
    Forem::Topic.find_each {|t| t.save! }
  end
end
