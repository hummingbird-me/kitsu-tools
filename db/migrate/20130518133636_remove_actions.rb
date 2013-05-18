class RemoveActions < ActiveRecord::Migration
  def up
    drop_table :actions
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
