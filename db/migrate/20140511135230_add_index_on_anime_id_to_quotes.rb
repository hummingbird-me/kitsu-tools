class AddIndexOnAnimeIdToQuotes < ActiveRecord::Migration
  def change
    add_index :quotes, :anime_id
  end
end
