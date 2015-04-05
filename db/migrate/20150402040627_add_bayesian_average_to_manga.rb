class AddBayesianAverageToManga < ActiveRecord::Migration
  def change
    add_column :manga, :bayesian_average, :float
    add_column :manga, :rating_frequencies, :hstore, default: {}, null: false
  end
end
