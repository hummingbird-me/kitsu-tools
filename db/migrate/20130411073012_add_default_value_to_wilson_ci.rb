class AddDefaultValueToWilsonCi < ActiveRecord::Migration
  def change
    change_column :anime, :wilson_ci, :float, default: 0
  end
end
