class WilsonScore
  def self.lower_bound(pos, n)
    if n == 0
      return 0
    end
    z = 1.96
    phat = 1.0*pos/n
    (phat + z*z/(2*n) - z * Math.sqrt((phat*(1-phat)+z*z/(4*n))/n))/(1+z*z/n)
  end
end
