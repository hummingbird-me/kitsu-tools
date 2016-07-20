class CleanUpFranchises < ActiveRecord::Migration
  def change
    ## Switch to Titleable concern
    add_column :franchises, :titles, :hstore, default: '', null: false
    add_column :franchises, :canonical_title, :string, null: false, default: 'en_jp'
    execute <<-SQL
      UPDATE franchises
      SET titles = hstore(ARRAY['en_jp', 'en'], ARRAY[romaji_title, english_title])
    SQL
    remove_column :franchises, :english_title
    remove_column :franchises, :romaji_title

    ## Clean join table
    # HABTM --> Installment
    rename_table :anime_franchises, :installments
    # Polymorphize
    add_column :installments, :media_type, :string
    execute "UPDATE installments SET media_type = 'Anime'"
    change_column_null :installments, :media_type, false
    rename_column :installments, :anime_id, :media_id
    remove_index :installments, :media_id
    add_index :installments, [:media_type, :media_id]
    # Add position and tag
    add_column :installments, :position, :integer, null: false, default: 0
    add_column :installments, :tag, :string
  end
end
