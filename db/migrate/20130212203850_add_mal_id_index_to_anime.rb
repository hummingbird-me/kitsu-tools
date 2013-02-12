class AddMalIdIndexToAnime < ActiveRecord::Migration
  def change
    add_index(:anime, [:mal_id], {:unique => true})
  end
end
