class AddMappings < ActiveRecord::Migration
  def change
    create_table :mappings do |t|
      t.string :external_site, null: false
      t.string :external_id, null: false
      t.references :media, polymorphic: true, null: false

      t.index [:external_site, :external_id, :media_type, :media_id],
        unique: true, name: 'index_mappings_on_external_and_media'
    end


    ######### Import the existing external IDs
    #### Anime
    ## MyAnimeList
    execute <<-SQL.squish
      INSERT INTO mappings (external_site, external_id, media_type, media_id)
      SELECT 'myanimelist/anime' AS external_site, mal_id AS external_id,
             'Anime' AS media_type, id AS media_id
      FROM anime
      WHERE mal_id IS NOT NULL
    SQL
    remove_column :anime, :mal_id

    ## TheTVDB
    execute <<-SQL.squish
      INSERT INTO mappings (external_site, external_id, media_type, media_id)
      SELECT 'thetvdb/series' AS external_site, thetvdb_series_id AS external_id,
             'Anime' AS media_type, id AS media_id
      FROM anime
      WHERE thetvdb_series_id IS NOT NULL
    SQL
    remove_column :anime, :thetvdb_series_id
    execute <<-SQL.squish
      INSERT INTO mappings (external_site, external_id, media_type, media_id)
      SELECT 'thetvdb/season' AS external_site, thetvdb_season_id AS external_id,
             'Anime' AS media_type, id AS media_id
      FROM anime
      WHERE thetvdb_season_id IS NOT NULL
    SQL
    remove_column :anime, :thetvdb_season_id

    ## AnimeNewsNetwork
    execute <<-SQL.squish
      INSERT INTO mappings (external_site, external_id, media_type, media_id)
      SELECT 'animenewsnetwork' AS external_site, ann_id AS external_id,
             'Anime' AS media_type, id AS media_id
      FROM anime
      WHERE ann_id IS NOT NULL
    SQL
    remove_column :anime, :ann_id

    #### Manga
    ## MyAnimeList
    execute <<-SQL.squish
      INSERT INTO mappings (external_site, external_id, media_type, media_id)
      SELECT 'myanimelist/manga' AS external_site, mal_id AS external_id,
             'Manga' AS media_type, id AS media_id
      FROM manga
      WHERE mal_id IS NOT NULL
    SQL
    remove_column :manga, :mal_id

    #### Drama
    ## MyAnimeList
    execute <<-SQL.squish
      INSERT INTO mappings (external_site, external_id, media_type, media_id)
      SELECT 'mydramalist' AS external_site, mdl_id AS external_id,
             'Drama' AS media_type, id AS media_id
      FROM dramas
      WHERE mdl_id IS NOT NULL
    SQL
    remove_column :dramas, :mdl_id
  end
end
