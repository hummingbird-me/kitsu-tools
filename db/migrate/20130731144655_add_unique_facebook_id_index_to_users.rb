class AddUniqueFacebookIdIndexToUsers < ActiveRecord::Migration
  def change
    add_index :users, :facebook_id, unique: true
  end
end
