class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :user
      t.references :anime
      t.boolean :positive
      t.text :content

      t.timestamps
    end
    add_index :reviews, :user_id
    add_index :reviews, :anime_id
  end
end
