class ChangeRecurringForDealPartners < ActiveRecord::Migration
  def change
    remove_column :partner_deals, :recurring, :boolean
    add_column :partner_deals, :recurring, :integer, default: 0
  end
end
