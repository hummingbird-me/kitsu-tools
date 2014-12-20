class RemoveNullConstraintFromPartnerCodes < ActiveRecord::Migration
  def change
    change_column_null :partner_codes, :user_id, true
  end
end
