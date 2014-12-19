class AddPartnerCodes < ActiveRecord::Migration
  def change
    create_table :partner_deals do |t|
      t.string :deal_title, null: false
      t.string :partner_name, null: false
      t.string :valid_countries, array: true, null: false

      t.index :valid_countries, using: 'gin'
    end
    create_table :partner_codes do |t|
      t.references :partner_deal, null: false
      t.string :code, null: false
      t.references :user, null: false
      t.timestamp :expires_at
      t.timestamp :claimed_at

      t.index [:partner_deal_id, :user_id], unique: true
    end
  end
end
