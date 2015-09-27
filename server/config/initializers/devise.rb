Devise.setup do |config|
  # ==> Mailer Configuration
  config.mailer_sender = 'josh@hummingbird.me'
  # config.mailer = 'Devise::Mailer'

  # ==> ORM configuration
  require 'devise/orm/active_record'

  # => Authentication Configuration
  config.authentication_keys = { email: false, username: false }
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]

  # ==> Configuration for :database_authenticatable
  # Increases time exponentially
  config.stretches = Rails.env.test? ? 1 : 11

  # ==> Configuration for :confirmable
  config.allow_unconfirmed_access_for = 7.days
  # Lifespan of Confirmation Link
  config.confirm_within = 7.days
  # Reconfirm on email changes
  config.reconfirmable = true

  # ==> Configuration for :validatable
  config.password_length = 8..128

  # ==> Configuration for :recoverable
  # Lifespan of Reset Token
  config.reset_password_within = 6.hours
  config.sign_in_after_reset_password = true
end
