class AddMalUsernameToUser < ActiveRecord::Migration
  def change
    add_column :users, :mal_username, :string
  end
end
