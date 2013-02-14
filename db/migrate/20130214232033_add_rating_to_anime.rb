class AddRatingToAnime < ActiveRecord::Migration
  def change
    add_column :watchlists, :rating, :integer
  end
end
