require 'chewy/rspec'

RSpec.configure do |config|
  config.before(:suite) do
    # Commit changes to the index immediately
    Chewy.strategy(:urgent)
  end
  config.before(:example, elasticsearch: true) do
    Chewy::Index.descendants.each(&:purge!)
  end
end
