class ChangeCastingsToPolymorphic < ActiveRecord::Migration
  def up
    rename_column :castings, :anime_id, :castable_id
    add_column :castings, :castable_type, :string
    Casting.reset_column_information
    Casting.update_all castable_type: "Anime"
    add_index :castings, [:castable_id, :castable_type]
    remove_index :castings, [:castable_id]
  end
  def down
    add_index :castings, [:castable_id]
    remove_index :castings, [:castable_id, :castable_type]
    rename_column :castings, :castable_id, :anime_id
    remove_column :castings, :castable_type
  end
end
