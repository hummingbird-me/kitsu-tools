class AddDefaultToValidCountries < ActiveRecord::Migration
  def change
    change_column_default :partner_deals, :valid_countries, []
  end
end
