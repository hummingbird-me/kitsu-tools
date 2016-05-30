class RenameTitleKey < ActiveRecord::Migration
  class Anime < ActiveRecord::Base; end
  class Drama < ActiveRecord::Base; end
  class Manga < ActiveRecord::Base; end
  class Episode < ActiveRecord::Base; end

  def change
    # Copy values from :ja_en to new key :en_jp
    execute <<-SQL
      UPDATE anime
      SET titles = titles || hstore('en_jp', titles -> 'ja_en')
    SQL

    execute <<-SQL
      UPDATE dramas
      SET titles = titles || hstore('en_jp', titles -> 'ja_en')
    SQL

    execute <<-SQL
      UPDATE manga
      SET titles = titles || hstore('en_jp', titles -> 'ja_en')
    SQL

    execute <<-SQL
      UPDATE episodes
      SET titles = titles || hstore('en_jp', titles -> 'ja_en')
    SQL

    # Update canonical_title values
    Anime.where(canonical_title: 'ja_en').update_all(canonical_title: 'en_jp')
    Drama.where(canonical_title: 'ja_en').update_all(canonical_title: 'en_jp')
    Manga.where(canonical_title: 'ja_en').update_all(canonical_title: 'en_jp')
    Episode.where(canonical_title: 'ja_en').update_all(canonical_title: 'en_jp')

    # Delete the old :ja_en key
    execute <<-SQL
      UPDATE anime
      SET titles = delete(titles, 'ja_en')
    SQL

    execute <<-SQL
      UPDATE dramas
      SET titles = delete(titles, 'ja_en')
    SQL

    execute <<-SQL
      UPDATE manga
      SET titles = delete(titles, 'ja_en')
    SQL

    execute <<-SQL
      UPDATE episodes
      SET titles = delete(titles, 'ja_en')
    SQL

    # Update canonical_title default
    change_column_default :anime, :canonical_title, 'en_jp'
    change_column_default :dramas, :canonical_title, 'en_jp'
    change_column_default :manga, :canonical_title, 'en_jp'
    change_column_default :episodes, :canonical_title, 'en_jp'
  end
end
