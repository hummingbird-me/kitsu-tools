class ChangeAllStringsToText < ActiveRecord::Migration
  def change
    change_column :anime, :title, :text
    change_column :anime, :alt_title, :text
    change_column :anime, :slug, :text
    change_column :anime, :cover_image_file_name, :text
    change_column :forem_topics, :subject, :text
  end
end
