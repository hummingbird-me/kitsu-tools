class CreateDrama < ActiveRecord::Migration
  def change
    create_table :dramas do |t|
      ## Title Info
      t.string :slug, null: false, index: true
      t.hstore :titles, default: {}, null: false
      t.string :canonical_title, default: 'ja_en', null: false
      t.string :abbreviated_titles, array: true

      ## Metadata
      # Age ratings
      t.integer :age_rating
      t.string :age_rating_guide
      # Episode info
      t.integer :episode_count
      t.integer :episode_length
      # Type of show
      t.integer :show_type
      t.date :start_date
      t.date :end_date
      t.boolean :started_airing_date_known, default: true, null: false
      # Synopsis
      t.text :synopsis
      # Trailer
      t.string :youtube_video_id
      # Country
      t.string :country, length: 2, default: 'ja', null: false

      ## Graphics
      t.attachment :cover_image
      t.attachment :poster_image
      t.integer :cover_image_top_offset, null: false, default: 0

      ## MyDramaList ID
      t.integer :mdl_id

      ## Rating, popularity
      t.float :average_rating
      t.hstore :rating_frequencies, null: false, default: {}
      t.integer :user_count, null: false, default: 0

      t.timestamps null: false
    end

    create_join_table :dramas, :genres
  end
end
