class CreateStreamingLinks < ActiveRecord::Migration
  def change
    change_table :streamers do |t|
      t.attachment :logo
    end
    create_table :streaming_links do |t|
      t.references :media, polymorphic: true, index: true, null: false
      t.references :streamer, index: true, foreign_key: true, null: false
      t.string :url, null: false
      t.string :subs, array: true, null: false, default: ['en']
      t.string :dubs, array: true, null: false, default: ['ja']
    end
  end
end
