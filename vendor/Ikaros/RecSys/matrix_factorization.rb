require_relative 'ratings.rb'

class MatrixFactorization
  # Mean and std dev of the normal distribution used to initialize the factors.
  attr_accessor :init_mean, :init_std_dev
  attr_accessor :num_factors, :learn_rate, :decay, :regularization, :num_iter
  def initialize
    # How to represent user and item factor matrices.
    @user_factors = Matrix.new
    @item_factors = Matrix.new
    @global_bias = nil
  end
end
