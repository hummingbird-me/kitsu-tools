class CleanCharacters < ActiveRecord::Migration
  def change
    change_table :characters do |t|
      t.references :primary_media, polymorphic: true
    end
  end
end
