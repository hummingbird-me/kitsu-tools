class ApplicationController < JSONAPI::ResourceController
  include DoorkeeperHelpers

  force_ssl if Rails.env.production?
end
