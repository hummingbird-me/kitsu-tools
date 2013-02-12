class CreateStagedImports < ActiveRecord::Migration
  def change
    create_table :staged_imports do |t|
      t.references :user
      t.text :data

      t.timestamps
    end
    add_index :staged_imports, :user_id
  end
end
