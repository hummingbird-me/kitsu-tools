task :stats => "hummingbird:stats_setup"

namespace :hummingbird do
  task :stats_setup do
    require 'rails/code_statistics'
    ::STATS_DIRECTORIES += {
      'Indices' => 'app/chewy',
      'Workers' => 'app/workers',
      'Resources' => 'app/resources',
      'Services' => 'app/services',
      'Policies' => 'app/policies'
    }.to_a
    ::STATS_DIRECTORIES.sort_by! { |dir| dir[0] }
  end
end
