class CreateEpisodeViews < ActiveRecord::Migration
  def change
    create_table :episode_views do |t|
      t.references :user
      t.references :anime
      t.references :episode

      t.timestamps
    end
    add_index :episode_views, :user_id
    add_index :episode_views, :anime_id
    add_index :episode_views, :episode_id
  end
end
