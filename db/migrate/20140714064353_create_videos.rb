class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :url, null: false
      t.string :embed_data, null: false
      t.string :available_regions, array: true, default: ['US'], index: true
      t.references :episode, index: true
      t.references :streamer

      t.timestamps
    end
    add_index :videos, [:episode_id, :streamer_id], unique: true
  end
end
