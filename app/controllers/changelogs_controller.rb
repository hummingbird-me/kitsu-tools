require 'open-uri'
require 'json'

class ChangelogsController < ApplicationController
  def index
  	# DEVNOTE: This is not really a solution, will eventually
  	# need to rewrite the PHP script to ruby.
  	# This will need to be cached, don't really know how to
  	# realize that yet but this works as a temp solution.
    data = open("http://hb.hummingboard.me/hbapi.php").read
    render json: data
  end
end
