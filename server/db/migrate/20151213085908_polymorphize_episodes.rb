class PolymorphizeEpisodes < ActiveRecord::Migration
  def change
    rename_column :episodes, :anime_id, :media_id
    change_column_null :episodes, :media_id, false
    add_column :episodes, :media_type, :string
    change_column_null :episodes, :media_type, false, 'Anime'
    add_index :episodes, [:media_type, :media_id]
    remove_index :episodes, :media_id
  end
end
