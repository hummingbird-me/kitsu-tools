class AddWilsonCiToAnime < ActiveRecord::Migration
  def change
    add_column :anime, :wilson_ci, :float
  end
end
