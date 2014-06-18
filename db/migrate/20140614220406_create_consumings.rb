class CreateConsumings < ActiveRecord::Migration
  def change
    create_table :consumings do |t|
      t.references :user, index: true
      t.references :item, polymorphic: true, index: true
      t.string :status
      t.boolean :private, :default => false
      t.integer :parts_consumed, :default => 0
      t.integer :blocks_consumed, :default => 0
      t.integer :reconsume_count, :default => 0
      t.boolean :reconsuming, :default => false
      t.datetime :last_consumed

      t.timestamps
    end
  end
end
