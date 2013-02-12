class CreateCastings < ActiveRecord::Migration
  def change
    create_table :castings do |t|
      t.references :anime
      t.references :person
      t.references :character
      t.string :type
      t.string :role

      t.timestamps
    end
    add_index :castings, :anime_id
    add_index :castings, :person_id
    add_index :castings, :character_id
  end
end
