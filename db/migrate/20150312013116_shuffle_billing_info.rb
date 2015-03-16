class ShuffleBillingInfo < ActiveRecord::Migration
  def change
    rename_column :users, :stripe_customer_id, :billing_id
    remove_column :users, :stripe_token
    add_column :users, :billing_method, :int

    User.update_all billing_method: 0
  end
end
