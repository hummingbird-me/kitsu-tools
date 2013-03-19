class AddThetvdbSeriesIdAndThetvdbSeasonIdToAnimes < ActiveRecord::Migration
  def change
    add_column :anime, :thetvdb_series_id, :string
    add_column :anime, :thetvdb_season_id, :string
  end
end
