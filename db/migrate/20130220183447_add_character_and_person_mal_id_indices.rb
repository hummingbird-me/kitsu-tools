class AddCharacterAndPersonMalIdIndices < ActiveRecord::Migration
  #   create unique index character_mal_id on characters (mal_id);
  #   create unique index person_mal_id on people (mal_id);
  def change
    add_index :characters, [:mal_id], {unique: true}
    add_index :people, [:mal_id], {unique: true}
  end
end
