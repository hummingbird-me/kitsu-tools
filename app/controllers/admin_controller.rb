class AdminController < ApplicationController
  http_basic_authenticate_with :name => "change", :password => "thislater"
  
  def index
  end
end
