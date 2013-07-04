class AddSortIndexToWatchlists < ActiveRecord::Migration
  def change
    add_index :watchlists, :created_at, order: {created_at: :desc}
    add_index :watchlists, :last_watched, order: {last_watched: :desc}
  end
end
