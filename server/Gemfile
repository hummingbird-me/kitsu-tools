source 'https://rubygems.org'
ruby '2.2.3'

# Core Stuff
gem 'rails', '4.2.1'
gem 'rails-api'
gem 'puma'

# Database Stuff
gem 'pg'
gem 'hiredis'
gem 'redis', require: ['redis', 'redis/connection/hiredis']
gem 'redis-rails'
gem 'connection_pool'

# Auth{entication,orization}
gem 'devise', '~> 3.5'
gem 'devise-async'
gem 'doorkeeper'
gem 'pundit'

# Attachments
gem 'paperclip', '~> 4.1'
gem 'paperclip-optimizer'
gem 'delayed_paperclip'
gem 'image_optim', require: false
gem 'aws-sdk'

# Background tasks
gem 'sidekiq', '~> 3.4.2'
gem 'sidetiq'

# Text pipeline
gem 'onebox'
gem 'twemoji', github: 'vevix/twemoji'

# Miscellaneous Utilities
gem 'friendly_id' # slug-urls-are-cool
gem 'nokogiri' # Parse MAL XML shit
gem 'active_model_serializers', '0.10.0.rc3' # JSON-API serialization
gem 'paranoia', '~> 2.0'

# Rack Middleware
gem 'rack-cors'

# Optimizations and Profiling
gem 'rack-mini-profiler'
gem 'flamegraph'
gem 'stackprof'
gem 'fast_blank' # Faster String#blank?
gem 'oj' # Blazing-fast JSON parsing

group :development, :test do
  gem 'foreman' # Start processes
  gem 'dotenv-rails' # Load default ENV
  gem 'pry-rails' # Better Console
  gem 'spring' # Faster CLI
  gem 'annotate', require: false # Schema annotations inside model-related files

  # Development+Testing
  gem 'factory_girl_rails' # Factories > Fixtures

  # HERE THERE BE DRAGONS: Remove and uncomment line below when rspec-rails is
  # released with a fix for rspec/rspec-rails#1430
  %w[rspec rspec-core rspec-expectations rspec-mocks rspec-rails
     rspec-support].each do |lib|
    gem lib, github: "rspec/#{lib}", branch: 'master'
  end
  # gem 'rspec-rails' # Specs > Tests

  # Guard notices filesystem changes and *does things*
  gem 'guard'
  gem 'guard-rspec', require: false # Running specs
end

group :test do
  gem 'shoulda-matchers' # it { should(:have_shoulda) }
  gem 'timecop' # stop [hammer-]time
  gem 'json_expressions' # Test outputted JSON
  gem 'rspec-sidekiq' # Test Sidekiq jobs
  gem 'faker' # Fake data
  gem 'fakeweb' # Web faking
  gem 'codeclimate-test-reporter', require: false

  # Libraries used to test our API itself
  gem 'oauth2'
end
