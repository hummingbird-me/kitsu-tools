class NormalizeReviewRatings < ActiveRecord::Migration
  def up
    Review.where(rating_story: nil).update_all rating_story: 0
    Review.where(rating_animation: nil).update_all rating_animation: 0
    Review.where(rating_sound: nil).update_all rating_sound: 0
    Review.where(rating_character: nil).update_all rating_character: 0
    Review.where(rating_enjoyment: nil).update_all rating_enjoyment: 0
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
