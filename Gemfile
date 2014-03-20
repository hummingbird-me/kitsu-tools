source 'https://rubygems.org'
ruby '2.1.0'

gem 'rails', '4.0.3'

# Pending switching to strong params.
gem 'protected_attributes'

gem 'annotate', require: false

gem 'grape'
gem 'grape-entity'
gem 'active_model_serializers', '~> 0.8'

gem 'riemann-client'
gem 'fastclick-rails'

gem 'pg', '0.15.1'

gem 'hiredis'
gem 'redis', require: ['redis', 'redis/connection/hiredis']
gem 'redis-rails'

gem 'ember-rails'
gem 'ember-source', '1.5.0.beta.1.1'
gem 'ember-data-source', '1.0.0.beta.7'
gem 'coffee-rails', '~> 4.0'
gem 'emblem-rails', '~> 0.2.1'
gem 'emblem-source', '~> 0.3.8'

gem 'react-rails', '~> 0.9.0.0'

gem 'indexable', '~> 0.1'
gem 'rinku'
gem 'rack-cors', require: 'rack/cors'
gem 'sanitize'
gem 'oj'

gem 'fast_blank' # Faster `String#blank?`, which is used a lot but ActiveRecord.


# Was assets group.
gem 'sass-rails',   '~> 4.0'
gem 'zurb-foundation', '~> 4.3.0'
gem 'therubyracer', :platforms => :ruby
gem 'uglifier', '>= 1.0.3'
gem 'handlebars_assets', github: 'vikhyat/handlebars_assets'
gem 'bootstrap-sass', '~> 3.1.0'
gem 'autoprefixer-rails'
gem 'non-stupid-digest-assets'

# Gems to help with development.
group :development do
  gem 'foreman'
  gem 'better_errors'
  gem 'letter_opener'
  gem 'binding_of_caller'
  gem 'guard-livereload', require: false
  gem 'rack-livereload'
  gem 'rb-fsevent', require: false
  gem 'qunit-rails'

  # Deploy with Capistrano
  gem 'capistrano', require: false
  gem 'rvm-capistrano', require: false
end

gem 'rack-mini-profiler'
gem 'flamegraph'
group :production do
  gem 'newrelic_rpm'
  gem 'newrelic-grape'
end

# Testing
group :test do
  gem 'simplecov'
  gem 'shoulda'
  gem 'timecop'
  gem 'mock_redis'
  gem 'mocha'
end

gem 'haml', '~> 4.0'
gem 'haml-rails'
gem 'simple_form'
gem 'rdiscount'

# Attachments
gem "paperclip", "~> 3.0"
gem 'paperclip-optimizer'
gem 'delayed_paperclip'
gem 'aws-sdk', '~> 1.5.7'

# Better URLs.
gem 'friendly_id', github: 'vikhyat/friendly_id'

# Authentication.
gem 'devise'
gem 'devise-async' # Async email for Devise
gem 'omniauth'
gem 'omniauth-facebook', '= 1.4.0'  # Using version 1.4.0 instead of the latest
                                    # because of an issue where the first time
                                    # (when the user authorizes the application),
                                    # the user is not logged in for some reason.
# Authorization.
gem 'cancan'

# For pagination.
gem 'kaminari'

# Background jobs
gem 'sidekiq'
gem 'sidekiq-throttler'
gem 'slim'

gem 'sinatra', :require => nil

gem 'pg_search', '~> 0.7'

# Admin panel
gem "rails_admin"

# Use Unicorn as the app server
gem 'unicorn'

# Needed for MAL import.
gem 'nokogiri', require: false

# Image optimization
gem 'image_optim', require: false

# Metrics
gem 'mixpanel'

# A/B Testing
gem 'split', require: 'split/dashboard'

# SEO
gem 'sitemap_generator'
