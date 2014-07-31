class RemoveUnusedIndexes < ActiveRecord::Migration
  def up
    remove_index :forem_views, name: :index_forem_views_on_updated_at
    remove_index :forem_views, name: :index_forem_views_on_user_id
    remove_index :forem_views, name: :index_forem_views_on_topic_id
    remove_index :favorites, name: :index_favorites_on_fav_rank
    remove_index :users, name: :index_users_on_website
    remove_index :users, name: :index_users_on_location
    remove_index :forem_posts, name: :index_forem_posts_on_state
    remove_index :forem_posts, name: :index_forem_posts_on_reply_to_id
    remove_index :forem_posts, name: :index_forem_posts_on_user_id
    remove_index :genres_manga, name: :index_genres_manga_on_genre_id
    remove_index :forem_topics, name: :index_forem_topics_on_state
    remove_index :forem_topics, name: :index_forem_topics_on_user_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
