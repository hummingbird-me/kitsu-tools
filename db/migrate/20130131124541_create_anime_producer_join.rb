class CreateAnimeProducerJoin < ActiveRecord::Migration
  def change
    create_table :animes_producers, :id => false do |t|
      t.integer :anime_id, :null => false
      t.integer :producer_id, :null => false
    end
  end
end
