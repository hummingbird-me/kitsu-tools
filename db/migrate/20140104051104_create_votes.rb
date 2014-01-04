class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :target, polymorphic: true, null: false
      t.references :user, null: false
      t.boolean :positive, default: true, null: false

      t.timestamps
    end

    add_index :votes, [:target_id, :target_type, :user_id], unique: true
  end
end
