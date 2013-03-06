class AddRatingsToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :rating_story, :integer
    add_column :reviews, :rating_animation, :integer
    add_column :reviews, :rating_sound, :integer
    add_column :reviews, :rating_character, :integer
    add_column :reviews, :rating_enjoyment, :integer
  end
end
