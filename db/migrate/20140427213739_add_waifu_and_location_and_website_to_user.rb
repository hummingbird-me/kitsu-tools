class AddWaifuAndLocationAndWebsiteToUser < ActiveRecord::Migration
  def change
    add_column :users, :waifu, :string
    add_index :users, :waifu
    add_column :users, :location, :string
    add_index :users, :location
    add_column :users, :website, :string
    add_index :users, :website
    add_column :users, :waifu_or_husbando, :string
    add_index :users, :waifu_or_husbando
  end
end
