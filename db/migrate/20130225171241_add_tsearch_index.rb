class AddTsearchIndex < ActiveRecord::Migration
  def up
    execute '
      CREATE INDEX anime_simple_search_index ON anime USING GIN( (to_tsvector(\'simple\', coalesce("anime"."title"::text, \'\')) || to_tsvector(\'simple\', coalesce("anime"."alt_title"::text, \'\'))) );
    '
  end

  def down
    execute '
      DROP INDEX anime_simple_search_index;
    '
  end
end
