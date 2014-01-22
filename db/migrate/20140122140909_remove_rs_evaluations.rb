class RemoveRsEvaluations < ActiveRecord::Migration
  def up
    drop_table :rs_evaluations
    drop_table :rs_reputations
    drop_table :rs_reputation_messages
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
