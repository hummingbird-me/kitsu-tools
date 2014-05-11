class AddIndexToAnimeProducers < ActiveRecord::Migration
  def change
    add_index :anime_producers, :anime_id
    add_index :anime_producers, :producer_id
  end
end
