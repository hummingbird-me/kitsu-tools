class AddMalImportInProgressToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mal_import_in_progress, :boolean
  end
end
