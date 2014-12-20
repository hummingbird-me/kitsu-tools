class AddFieldsToPartnerDeal < ActiveRecord::Migration
  def change
    change_table :partner_deals do |t|
      t.has_attached_file :partner_logo
      t.text :deal_url, null: false
      t.text :deal_description, null: false
      t.text :redemption_info, null: false
      t.boolean :recurring, null: false, default: false
      t.boolean :active, null: false, default: true
    end
  end
end
