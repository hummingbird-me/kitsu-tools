class AddFormattedHtmlToForemPosts < ActiveRecord::Migration
  include ActionView::Helpers
  include ERB::Util
  include Forem::ApplicationHelper

  def up
    add_column :forem_posts, :formatted_html, :text
    #Forem::Post.where(formatted_html: nil).find_each do |post|
    #  post.formatted_html = forem_format(post.text)
    #  post.save
    #end
  end

  def down
    remove_column :forem_posts, :formatted_html, :text
  end
end
