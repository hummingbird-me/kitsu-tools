class BiasedMatrixFactorization
  FOLD_IN_BIAS_INDEX = 0
  FOLD_IN_FACTORS_START = 1

  def initialize(ratings)
    @bias_reg = 0.01
    @bias_learn_rate = 1.0
    @ratings = ratings

  end
end
