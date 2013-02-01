class RenameQuoteCharacterToCharacterName < ActiveRecord::Migration
  def change
    rename_column :quotes, :character, :character_name
  end
end
