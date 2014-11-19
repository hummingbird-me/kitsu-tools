class AddSlugToCharacters < ActiveRecord::Migration
  def change
    change_table :characters do |t|
      # TODO: switch this to non-null, add unique index
      t.string :slug
    end
  end
end
