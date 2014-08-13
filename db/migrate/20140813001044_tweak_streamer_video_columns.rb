class TweakStreamerVideoColumns < ActiveRecord::Migration
  def change
    change_table :videos do |t|
      t.string :sub_lang
      t.string :dub_lang
    end
    change_table :streamers do |t|
      t.remove :oembed_uri
    end
  end
end
