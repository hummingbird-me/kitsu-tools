class AddOAuthToApp < ActiveRecord::Migration
  def change
    add_column :apps, :redirect_uri, :string
    add_column :apps, :homepage, :string
    add_column :apps, :description, :string
    add_column :apps, :privileged, :boolean, null: false, default: false
    add_attachment :apps, :logo
  end
end
