class CreateListImports < ActiveRecord::Migration
  def change
    create_table :list_imports do |t|
      # STI type such as ListImport::MyAnimeList
      t.string :type, null: false
      # Owner
      t.references :user, null: false
      # Strategy (:greater, :obliterate)
      t.integer :strategy, null: false
      # Inputs
      t.attachment :input_file
      t.text :input_text
      # Progress/status
      t.integer :status, null: false, default: 0
      t.integer :progress
      t.integer :total
      # Error info
      t.text :error_message
      t.text :error_trace
      # Timestamps
      t.timestamps null: false
    end
  end
end
