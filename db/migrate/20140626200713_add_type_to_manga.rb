class AddTypeToManga < ActiveRecord::Migration
  def change
    add_column :manga, :type, :string, :default => "Manga"
  end
end
