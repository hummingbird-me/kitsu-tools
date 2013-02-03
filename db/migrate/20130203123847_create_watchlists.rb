class CreateWatchlists < ActiveRecord::Migration
  def change
    create_table :watchlists do |t|
      t.references :user
      t.references :anime
      t.boolean :positive
      t.string :status

      t.timestamps
    end
    add_index :watchlists, :user_id
    add_index :watchlists, :anime_id
  end
end
