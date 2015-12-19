class CreateProMembershipPlans < ActiveRecord::Migration
  def change
    create_table :pro_membership_plans do |t|
      t.string :name, null: false
      t.integer :amount, null: false
      t.integer :duration, null: false
      t.boolean :recurring, null: false, default: false
      t.timestamps null: false
    end
  end
end
