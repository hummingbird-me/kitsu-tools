class RemoveDefaultAverageRatingAndMoveMangaAverageRatingToCorrectColumn < ActiveRecord::Migration
  def change
    change_column_null :anime, :average_rating, true
    reversible do |dir|
      dir.up do
        change_column_default :anime, :average_rating, nil
        execute 'UPDATE anime SET average_rating=NULL WHERE average_rating = 0'
      end
      dir.down do
        change_column_default :anime, :average_rating, 0.0
        execute 'UPDATE anime SET average_rating=0 WHERE average_rating = NULL'
      end
    end
    rename_column :manga, :bayesian_rating, :average_rating
  end
end
