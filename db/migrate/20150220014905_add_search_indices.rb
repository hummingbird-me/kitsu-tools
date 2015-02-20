class AddSearchIndices < ActiveRecord::Migration
  def up
    # Anime indices
    rename_index :anime, :anime_search_index, :anime_trigram_search_index
    remove_index :anime, name: 'anime_simple_search_index'
    execute <<-SQL
      CREATE INDEX anime_text_search_index
      ON anime
      USING gin (((to_tsvector('english', coalesce("anime"."title"::text, ''))
                || to_tsvector('english', coalesce("anime"."alt_title"::text, '')) )))
    SQL

    # Manga indices
    rename_index :manga, :manga_fuzzy_search_index, :manga_trigram_search_index
    remove_index :manga, name: 'manga_simple_search_index'
    execute <<-SQL
      CREATE INDEX manga_text_search_index
      ON manga
      USING gin (((to_tsvector('english', coalesce("manga"."romaji_title"::text, ''))
                || to_tsvector('english', coalesce("manga"."english_title"::text, '')) )))
    SQL

    # Group indices
    execute <<-SQL
      CREATE INDEX groups_trigram_search_index
      ON groups
      USING gin ((coalesce("groups"."name"::text, '')
               || ' '
               || coalesce("groups"."bio"::text, '')) gin_trgm_ops)
    SQL
    execute <<-SQL
      CREATE INDEX groups_text_search_index
      ON groups
      USING gin (((setweight(to_tsvector('english', coalesce("groups"."name"::text, '')), 'A')
                || setweight(to_tsvector('english', coalesce("groups"."bio"::text, '')), 'B')
                || setweight(to_tsvector('english', coalesce("groups"."about"::text, '')), 'C') )))
    SQL
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
