require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'coffee_script'

# require_dependency doesn't work here for some reason.
require_relative '../lib/log_before_timeout.rb'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(:default, Rails.env)
end

module Hummingbird
  class Application < Rails::Application
    config.cache_store = :redis_store,
      (ENV["REDIS_URL"] || "redis://localhost:6379/0") + "/cache"

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.paths.add "app/api", glob: "**/*.rb"
    config.autoload_paths += Dir["#{config.root}/app/api/*"]
    config.autoload_paths += Dir["#{config.root}/app/serializers/*"]

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.i18n.enforce_available_locales = false

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    config.active_record.schema_format = :sql

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.assets.paths << Rails.root.join("app", "assets", "fonts")

    config.generators do |g|
      g.orm :active_record
    end

    # Add LogBeforeTimeout middleware
    config.middleware.insert_before Rack::Sendfile, LogBeforeTimeout

    # Add Rack::Attack
    config.middleware.use Rack::Attack

    # Get rid of Rack::Lock
    config.middleware.delete Rack::Lock

    # CORS configuration.
    config.middleware.use Rack::Cors do
      allow do
        origins "forums.hummingbird.me", "forumstaging.hummingbird.me", "localhost:4000"
        resource '/api/v1/*', headers: :any, methods: [:get]
      end
    end
  end
end
