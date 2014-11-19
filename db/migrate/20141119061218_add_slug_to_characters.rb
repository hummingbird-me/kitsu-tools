class AddSlugToCharacters < ActiveRecord::Migration
  def change
    change_table :characters do |t|
      t.string :slug, null: false
      t.index :slug, unique: true
    end
  end
end
