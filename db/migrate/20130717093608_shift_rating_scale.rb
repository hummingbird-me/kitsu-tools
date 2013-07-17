class ShiftRatingScale < ActiveRecord::Migration
  def up
    Watchlist.find_each do |w|
      if w.rating
        w.update_column :rating, w.rating+3
      end
    end
  end

  def down
  end
end
