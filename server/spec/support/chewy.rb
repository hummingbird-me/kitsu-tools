require 'chewy/rspec'

RSpec.configure do |config|
  config.before(:suite) do
    # Commit changes to the index immediately
    Chewy.strategy(:urgent)
  end
  config.before(:example, elasticsearch: true) do
    Chewy.client.cluster.health wait_for_status: 'yellow', timeout: '5s'
    Chewy::Index.descendants.each(&:purge!)
  end
end
