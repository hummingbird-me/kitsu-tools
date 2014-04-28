class AddWaifuSlugToUser < ActiveRecord::Migration
  def change
    add_column :users, :waifu_slug, :string, default: "#"
    add_index :users, :waifu_slug
    add_column :users, :waifu_char_id, :string, default: "0000"
    add_index :users, :waifu_char_id
 end
end
