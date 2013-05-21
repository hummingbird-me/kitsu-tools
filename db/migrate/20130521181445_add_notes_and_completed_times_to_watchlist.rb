class AddNotesAndCompletedTimesToWatchlist < ActiveRecord::Migration
  def change
    add_column :watchlists, :notes, :text
    add_column :watchlists, :rewatched_times, :integer, default: 0
  end
end
