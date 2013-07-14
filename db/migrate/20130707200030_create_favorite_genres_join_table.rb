class CreateFavoriteGenresJoinTable < ActiveRecord::Migration
  def change
    create_table :favorite_genres_users, id: false do |t|
      t.belongs_to :genre
      t.belongs_to :user
    end
    
    add_index :favorite_genres_users, [:genre_id, :user_id], unique: true
  end
end
