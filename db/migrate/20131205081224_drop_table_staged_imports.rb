class DropTableStagedImports < ActiveRecord::Migration
  def up
    drop_table :staged_imports
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
