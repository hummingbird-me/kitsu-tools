class TrendingGroupsRefreshWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { minutely(5) }  

  def perform
    TrendingGroup.connection.execute('REFRESH MATERIALIZED VIEW trending_groups')
  end
end
