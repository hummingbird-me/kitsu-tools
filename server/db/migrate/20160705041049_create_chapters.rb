class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      # belongs_to manga
      t.references :manga, index: true

      ## Title Info
      t.hstore :titles, default: {}, null: false
      t.string :canonical_title, default: 'en_jp', null: false

      ## Metadata
      # Chapter Number
      t.integer :number, null: false
      # Volume chapter is in
      t.integer :volume
      # Total Pages
      t.integer :length
      # Synopsis
      t.text :synopsis
      # When it was published in magazine
      t.date :published
      t.timestamps null: false
    end
  end
end
