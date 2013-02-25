class AddSearchIndices < ActiveRecord::Migration
  def up
    execute '
      CREATE INDEX anime_search_index ON anime USING gin(((COALESCE((title)::text, \'\'::text) || \' \'::text) || COALESCE((alt_title)::text, \'\'::text)) gin_trgm_ops);
    '
  end

  def down
    execute "
      DROP INDEX anime_search_index;
    "
  end
end
