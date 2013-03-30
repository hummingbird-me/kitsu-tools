def ci_lower_bound(pos, n)
  return 0 if n == 0
  
  # z=1.96 corresponds to confidence=0.95
  # z=2.17 corresponds to confidence=0.97
  z = 2.17

  phat = 1.0*pos/n
  (phat + z*z/(2*n) - z * Math.sqrt((phat*(1-phat)+z*z/(4*n))/n))/(1+z*z/n)
end

namespace :compute do
  desc "Compute the lower bound of the Wilson score CI for each anime"
  task :wilson_ci => :environment do |t|
    # NOTE This doesn't actually compute the Wilson CI, rather it computes a
    #      Bayesian average.
    #
    #      See: http://masanjin.net/blog/how-to-rank-products-based-on-user-input
    #prior = (-2..2).map {|x| Watchlist.where(rating: x).count }
    prior = [2, 2, 2, 2, 2]
    Anime.where({}).each do |anime|
      votes = (-2..2).map {|x| anime.watchlists.where(rating: x).count }
      posterior = votes.zip(prior).map {|a, b| a + b }
      sum = posterior.sum
      score = posterior.map.with_index {|v, i| (i + 1) * v }.inject {|a, b| a + b }.to_f / sum
      anime.wilson_ci = (score - 1.0) / 4
      anime.user_count = anime.watchlists.count
      anime.save
    end
    # After computing the ratings, normalize them so that they span the range
    # [0.1, 1].
    min = Anime.all.map {|x| x.wilson_ci }.min
    max = Anime.all.map {|x| x.wilson_ci }.max
    Anime.where({}).each do |anime|
      anime.wilson_ci = 0.1 + 0.9 * (anime.wilson_ci - min) / (max - min)
      anime.save
    end
  end
end
