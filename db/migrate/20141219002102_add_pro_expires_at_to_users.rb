class AddProExpiresAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pro_expires_at, :timestamp
  end
end
