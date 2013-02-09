class ConvertAnimeTitleToString < ActiveRecord::Migration
  def change
    change_column :anime, :title, :string
    change_column :anime, :alt_title, :string
    change_column :anime, :slug, :string
    change_column :anime, :cover_image_file_name, :string
    change_column :forem_topics, :subject, :string
  end
end
