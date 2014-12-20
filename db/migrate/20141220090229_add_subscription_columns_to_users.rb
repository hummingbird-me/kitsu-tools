class AddSubscriptionColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stripe_token, :string
    add_column :users, :pro_membership_plan_id, :integer
  end
end
