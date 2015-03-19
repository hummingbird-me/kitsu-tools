class TrendingGroupsRefreshWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  # Because minutely(int) is slow as balls
  # See tobiassvn/sidetiq#31
  recurrence { hourly.minute_of_hour(00, 05, 10, 15, 20, 25,
                                     30, 35, 40, 45, 50, 55) }

  def perform
    TrendingGroup.connection.execute('REFRESH MATERIALIZED VIEW trending_groups')
  end
end
