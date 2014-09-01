class AddDropboxTokenToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :dropbox_token
      t.string :dropbox_secret
    end
  end
end
