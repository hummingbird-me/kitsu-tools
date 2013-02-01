class ChangeQuoteCharacterToString < ActiveRecord::Migration
  def change
    remove_column :quotes, :character_id
    add_column :quotes, :character, :string
  end
end
