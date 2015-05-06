class BayesianUpdateWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  def perform
    Anime.recompute_bayesian_ratings!
  end
end
