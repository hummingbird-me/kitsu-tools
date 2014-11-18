class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.references :reportable, polymorphic: true, null: false
      t.integer :reason, null: false
      t.text :comments
      t.references :reporter, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
