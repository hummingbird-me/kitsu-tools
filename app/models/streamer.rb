# == Schema Information
#
# Table name: streamers
#
#  id         :integer          not null, primary key
#  site_name  :string(255)      not null
#  oembed_uri :string(255)
#

class Streamer < ActiveRecord::Base
end
