class AddMangaSearchIndexes < ActiveRecord::Migration
  def up
    execute <<-END
      CREATE INDEX manga_fuzzy_search_index ON manga USING gin( ((coalesce("manga"."romaji_title"::text, '') || ' ' || coalesce("manga"."english_title"::text, ''))) gin_trgm_ops );
      CREATE INDEX manga_simple_search_index ON manga USING gin( (to_tsvector('simple', coalesce("manga"."romaji_title"::text, '')) || to_tsvector('simple', coalesce("manga"."english_title"::text, ''))) );
    END
  end

  def down
    execute <<-END
      DROP INDEX manga_fuzzy_search_index;
      DROP INDEX manga_simple_search_index;
    END
  end
end
