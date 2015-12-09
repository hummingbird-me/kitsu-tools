RSpec.configure do |config|
  # Expectations/assertions
  config.expect_with :rspec do |expectations|
    # Will be default in RSpec 4
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # Mocks
  config.mock_with :rspec do |mocks|
    # Will be default in RSpec 4
    mocks.verify_partial_doubles = true
  end

  # Allow filtering by "focus" tag
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  # Disable monkey-patched syntaxes
  config.disable_monkey_patching!

  # Be more verbose when running a single test
  config.default_formatter = 'doc' if config.files_to_run.one?

  # Show the 10 slowest specs
  config.profile_examples = 2

  # Randomize - if there's an order where the tests break, a seed can be passed
  # in via --seed to reproduce
  config.order = :random
  Kernel.srand config.seed
end
