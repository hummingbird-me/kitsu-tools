class BayesianAverageToBayesianRating < ActiveRecord::Migration
  def change
    rename_column :anime, :bayesian_average, :bayesian_rating
    rename_column :manga, :bayesian_average, :bayesian_rating
  end
end
