require 'chewy/rspec'

RSpec.configure do |config|
  config.before(:suite) do
    # Commit changes to the index immediately
    Chewy.strategy(:urgent)
    # Reset all the indices before we start
    Chewy::Index.descendants.each do |index|
      puts "Resetting #{index.name}"
      index.reset!
    end
  end
end
