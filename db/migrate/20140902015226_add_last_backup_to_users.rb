class AddLastBackupToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.timestamp :last_backup
    end
  end
end
