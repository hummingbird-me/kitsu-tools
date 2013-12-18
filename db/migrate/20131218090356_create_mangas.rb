class CreateMangas < ActiveRecord::Migration
  def change
    create_table :manga do |t|
      t.string :romaji_title
      t.string :slug
      t.string :english_title
      t.text :synopsis
      t.attachment :poster_image
      t.attachment :cover_image
      t.date :start_date
      t.date :end_date
      t.string :serialization
      t.integer :mal_id

      t.timestamps
    end
  end
end
