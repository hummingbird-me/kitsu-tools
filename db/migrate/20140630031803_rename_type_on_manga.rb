class RenameTypeOnManga < ActiveRecord::Migration
  def change
    rename_column :manga, :type, :manga_type
  end
end
