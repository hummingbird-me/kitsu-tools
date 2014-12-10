class ConvertThetvdbIdsToNumbers < ActiveRecord::Migration
  def up
    Anime.where(thetvdb_series_id: "").update_all thetvdb_series_id: nil
    Anime.where(thetvdb_season_id: "").update_all thetvdb_season_id: nil
    change_column :anime, :thetvdb_series_id, 'integer USING CAST(thetvdb_series_id AS integer)'
    change_column :anime, :thetvdb_season_id, 'integer USING CAST(thetvdb_season_id AS integer)'
    Anime.where('thetvdb_series_id <= 0').update_all thetvdb_series_id: nil
  end

  def down
    change_column :anime, :thetvdb_series_id, :string
    change_column :anime, :thetvdb_season_id, :string
  end
end
