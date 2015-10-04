class CleanAnimeMore < ActiveRecord::Migration
  def change
    # Unify column names with manga and genericize bayesian_rating name
    rename_column :anime, :started_airing_date, :start_date
    rename_column :anime, :finished_airing_date, :end_date
    rename_column :anime, :bayesian_rating, :average_rating
    # Convert show_type to enum
    change_column :anime, :show_type, "integer USING (
      CASE show_type
      WHEN 'TV' THEN 1
      WHEN 'Special' THEN 2
      WHEN 'OVA' THEN 3
      WHEN 'ONA' THEN 4
      WHEN 'Movie' THEN 5
      WHEN 'Music' THEN 6
      END
    )"
    # Migrate jp_title into hstore
    execute <<-SQL
      UPDATE anime
      SET titles = titles || hstore('ja_jp', jp_title)
    SQL
    remove_column :anime, :jp_title
  end
end
