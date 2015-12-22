namespace :search do
  desc 'Populate the ElasticSearch indices from the Postgres database'
  task import: :environment do
    AnimeIndex.import
  end
end
