class AddRatingFrequenciesToAnime < ActiveRecord::Migration
  def change
    add_column :anime, :rating_frequencies, :hstore
  end
end
