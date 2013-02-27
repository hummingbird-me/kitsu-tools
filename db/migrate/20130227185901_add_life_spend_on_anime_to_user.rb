class AddLifeSpendOnAnimeToUser < ActiveRecord::Migration
  def change
    add_column :users, :life_spent_on_anime, :integer
  end
end
