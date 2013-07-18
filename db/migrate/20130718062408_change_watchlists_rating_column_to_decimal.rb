class ChangeWatchlistsRatingColumnToDecimal < ActiveRecord::Migration
  def up
    change_column :watchlists, :rating, :decimal, precision: 2, scale: 1
  end

  def down
    change_column :watchlists, :rating, :integer
  end
end
