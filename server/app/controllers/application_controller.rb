require 'deserializer/helper'

class ApplicationController < ActionController::API
  include Deserializer::Helper
  include Pundit
  include ErrorHelpers
  include DoorkeeperHelpers

  force_ssl if Rails.env.production?
end
