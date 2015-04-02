class MakeWaifuSuckLess < ActiveRecord::Migration
  def change
    # Remove the waifu slug and name cache columns
    remove_column :users, :waifu_slug, :string
    remove_column :users, :waifu, :string

    reversible do |dir|
      dir.up do
        # Rename waifu_char_id to waifu_id
        rename_column :users, :waifu_char_id, :waifu_id

        # Remove the default value and make it nullable
        execute <<-SQL
          ALTER TABLE users
          ALTER COLUMN waifu_id DROP DEFAULT
        SQL
        change_column_null :users, :waifu_id, true

        # Null the column where it's the default
        execute <<-SQL
          UPDATE users
          SET waifu_id = DEFAULT
          WHERE waifu_id = '0000'
        SQL

        # Cast it to integer
        change_column :users, :waifu_id, 'integer USING CAST(waifu_id AS integer)'
      end
      dir.down do
        rename_column :users, :waifu_id, :waifu_char_id
        change_column_default :users, :waifu_char_id, '0000'
        change_column_null :users, :waifu_char_id, false
        execute <<-SQL
          UPDATE users
          SET waifu_char_id = DEFAULT
          WHERE waifu_char_id = NULL
        SQL
      end
    end
  end
end
