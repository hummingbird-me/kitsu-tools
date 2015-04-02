namespace :compute do
  desc "Compute the Bayesian average rating for every show"
  task :bayesian_average => :environment do |t|
    Anime.recompute_bayesian_averages!
  end
end
