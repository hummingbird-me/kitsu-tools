class DeleteConsumingTable < ActiveRecord::Migration
  def change
    drop_table :consumings
  end
end
