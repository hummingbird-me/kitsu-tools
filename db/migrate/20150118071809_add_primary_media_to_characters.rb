class AddPrimaryMediaToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :primary_media_id, :int
    add_column :characters, :primary_media_type, :string

    Character.find_each do |character|
      character.update primary_media: character.appearances.first
    end
  end
end
