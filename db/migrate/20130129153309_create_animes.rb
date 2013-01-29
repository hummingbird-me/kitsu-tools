class CreateAnimes < ActiveRecord::Migration
  def change
    create_table :animes do |t|
      t.string :age_rating
      t.integer :episode_count
      t.integer :episode_length
      t.string :status
      t.text :synopsis
      t.integer :mal_id

      t.timestamps
    end
  end
end
