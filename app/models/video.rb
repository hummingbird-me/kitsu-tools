# == Schema Information
#
# Table name: videos
#
#  id                :integer          not null, primary key
#  url               :string(255)      not null
#  embed_data        :string(255)      not null
#  available_regions :string(255)      default(["US"]), is an Array
#  episode_id        :integer
#  streamer_id       :integer
#  created_at        :datetime
#  updated_at        :datetime
#

class Video < ActiveRecord::Base
  belongs_to :episode
  belongs_to :streamer
end
