class DefaultRatingFrequenciesToEmptyHash < ActiveRecord::Migration
  def change
    change_column :anime, :rating_frequencies, :hstore, default: '', null: false
  end
end
