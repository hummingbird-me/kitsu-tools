class AddUserCountToAnime < ActiveRecord::Migration
  def change
    add_column :anime, :user_count, :integer
  end
end
