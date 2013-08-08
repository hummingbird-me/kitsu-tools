class RemoveStatusFromAnime < ActiveRecord::Migration
  def up
    remove_column :anime, :status
  end

  def down
    add_column :anime, :status, :string
  end
end
