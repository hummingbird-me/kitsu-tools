class AddAnnIdToAnime < ActiveRecord::Migration
  def change
    add_column :anime, :ann_id, :integer
  end
end
