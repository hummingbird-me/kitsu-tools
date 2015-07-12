class SplitMalImportColumnOnUsers < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.integer :import_status
      t.string :import_from
      t.string :import_error

      # status is enum queued: 1, running: 2, complete: 3, error: 4
      User.where(mal_import_in_progress: true)
          .update_all(import_status: 2, import_from: 'myanimelist')

      t.remove :mal_import_in_progress
    end
  end
end
