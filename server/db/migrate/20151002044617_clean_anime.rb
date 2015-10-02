class CleanAnime < ActiveRecord::Migration
  def change
    # G => 1, PG => 2, R => 3, X => 4
    change_column :anime, :age_rating, "integer USING (
      CASE age_rating
      WHEN 'G' THEN 1
      WHEN 'TV-Y7' THEN 1
      WHEN 'PG' THEN 2
      WHEN 'PG13' THEN 2
      WHEN 'R17+' THEN 3
      WHEN 'R18+' THEN 4
      END
    )"

    # titles: {
    #   en: 'Attack on Titan',
    #   ja_jp: '進撃の巨人',
    #   ja_en: 'Shingeki no Kyojin',
    #   es: 'Ataque a los Titanes',
    #   it: 'L\'Attacco dei Giganti',
    #   fr: 'L\'Attaque des Titans',
    #   zh_tw: '進擊的巨人',
    #   ko: '진격의 거인'
    # },
    # abbreviated_titles: ['AoT', 'SnK']
    # canonical_title: 'en',
    add_column :anime, :titles, :hstore, default: '', null: false
    add_column :anime, :canonical_title, :string, null: false, default: 'ja_en'
    add_column :anime, :abbreviated_titles, :string, array: true

    # title = romaji title
    # alt_title = english title
    # english_canonical = whether title or alt_title is canonical
    execute <<-SQL
      UPDATE anime
      SET titles = hstore(ARRAY['ja_en', 'en'], ARRAY[title, alt_title])
    SQL
    execute <<-SQL
      UPDATE anime
      SET canonical_title = 'en'
      WHERE english_canonical = true
    SQL

    remove_column :anime, :title
    remove_column :anime, :alt_title
    remove_column :anime, :english_canonical
  end
end
