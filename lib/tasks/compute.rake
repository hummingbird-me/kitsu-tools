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
    pre = YAML.load File.read("import/like_dislike.yaml")
    Anime.each do |anime|
      # TODO consider user ratings as well, not just the pre bias.
      pos = (pre[anime.mal_id] || [0, 0])[0]
      neg = (pre[anime.mal_id] || [0, 0])[1]
      anime.wilson_ci = ci_lower_bound(pos, pos+neg)
      anime.user_count = pos+neg
      anime.save
    end
  end
end
