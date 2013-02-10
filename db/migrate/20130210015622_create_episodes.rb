class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.references :anime
      t.integer :number
      t.string :title

      t.timestamps
    end
    add_index :episodes, :anime_id
  end
end
