class RemoveBetaInvitesTable < ActiveRecord::Migration
  def up
    drop_table :beta_invites
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
