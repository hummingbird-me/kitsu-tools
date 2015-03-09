class AddAboutFormattedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :about_formatted, :text
    add_column :groups, :about_formatted, :text
  end
end
