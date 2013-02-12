class AddMalIdToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :mal_id, :integer
  end
end
