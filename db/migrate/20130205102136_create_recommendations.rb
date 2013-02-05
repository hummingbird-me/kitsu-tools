class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.references :user
      t.references :anime
      t.float :score

      t.timestamps
    end
    add_index :recommendations, :user_id
    add_index :recommendations, :anime_id
  end
end
