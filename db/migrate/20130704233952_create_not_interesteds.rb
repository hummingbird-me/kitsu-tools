class CreateNotInteresteds < ActiveRecord::Migration
  def change
    create_table :not_interesteds do |t|
      t.references :user
      t.references :media, polymorphic: true, index: true

      t.timestamps
    end
    add_index :not_interesteds, :user_id
  end
end
