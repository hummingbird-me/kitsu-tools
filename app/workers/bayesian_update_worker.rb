class BayesianUpdateWorker
  include Sidekiq::Worker
  include Sidetiq::Scheduleable

  recurrence { daily }

  def perform
    Anime.recompute_bayesian_averages!
  end
end
