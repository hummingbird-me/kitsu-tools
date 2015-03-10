class UpdateIndexOnPartnerCodes < ActiveRecord::Migration
  def change
    # remove unique constraint
    remove_index :partner_codes, [:partner_deal_id, :user_id]
    add_index :partner_codes, [:partner_deal_id, :user_id]
  end
end
