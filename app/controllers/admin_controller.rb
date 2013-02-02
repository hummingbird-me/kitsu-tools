class AdminController < ApplicationController
  http_basic_authenticate_with :name => "change", :password => "thislater"
  
  def index
    @quotes_pending_moderation = Quote.where("visible IS NULL OR visible = ?", false)
  end
end
