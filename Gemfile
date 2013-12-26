source 'https://rubygems.org'

gem 'rails', '3.2.16'

gem 'grape'
gem 'grape-entity'
gem 'active_model_serializers', '~> 0.8'

gem 'riemann-client'
gem 'fastclick-rails'

gem 'pg'
gem 'activerecord-postgres-hstore'

gem 'redis'
gem 'redis-rails'

gem 'ember-rails'
gem 'ember-source', '1.2.0'
gem 'ember-data-source', '1.0.0.beta.4'
gem 'coffee-rails', '~> 3.2.1'
gem 'emblem-rails', '~> 0.2.1'

gem 'beaneater'
gem 'beanstalkd_view'

gem 'indexable', '~> 0.1'

gem 'rinku'

gem 'rack-mini-profiler'

gem 'rack-cors', require: 'rack/cors'

gem 'sanitize'

# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'compass-rails'
  gem 'zurb-foundation', '~> 4.3.0'
  gem 'therubyracer', :platforms => :ruby
  gem 'uglifier', '>= 1.0.3'
  gem 'handlebars_assets', github: 'vikhyat/handlebars_assets'
  gem 'anjlab-bootstrap-rails', require: 'bootstrap-rails',
                                github: 'anjlab/bootstrap-rails'
  gem 'autoprefixer-rails'
end

gem 'sunspot_rails'

# Gems to help with development.
group :development do
  gem 'sunspot_solr'
  gem "better_errors"
  gem "letter_opener"
  gem "binding_of_caller"
  gem 'guard-livereload', require: false
  gem 'rack-livereload'
  gem 'rb-fsevent', require: false
  gem 'qunit-rails'
end

gem 'skylight', '0.1.8'

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
end

gem 'jquery-rails'
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
gem 'friendly_id', '~> 4.0.9'

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

# For voting on stuff.
gem "activerecord-reputation-system", require: 'reputation_system'

# Use Unicorn as the app server
gem 'unicorn'

# Needed for MAL import.
gem 'nokogiri', require: false

# Deploy with Capistrano
gem 'capistrano'
gem 'rvm-capistrano'

# Image optimization
gem 'image_optim', require: false

# Metrics
gem 'mixpanel'

# A/B Testing
gem 'split', require: 'split/dashboard'

# SEO
gem 'sitemap_generator'
