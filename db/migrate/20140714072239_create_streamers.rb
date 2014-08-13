class CreateStreamers < ActiveRecord::Migration
  def change
    create_table :streamers do |t|
      t.string :site_name, null: false
      t.string :oembed_uri
    end
  end
end
