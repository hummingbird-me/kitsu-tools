class RenameWilsonCiToBayesianAverage < ActiveRecord::Migration
  def change
    rename_column :anime, :wilson_ci, :bayesian_average
  end
end
