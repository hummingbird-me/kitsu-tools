class DropEpisodeViewTable < ActiveRecord::Migration
  def change
    drop_table :episodes_watchlists
  end
end
