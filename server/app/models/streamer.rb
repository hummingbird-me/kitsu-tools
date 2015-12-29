# == Schema Information
#
# Table name: streamers
#
#  id                :integer          not null, primary key
#  site_name         :string(255)      not null
#  logo_file_name    :string
#  logo_content_type :string
#  logo_file_size    :integer
#  logo_updated_at   :datetime
#

class Streamer < ActiveRecord::Base
  has_attached_file :logo

  validates :site_name, presence: true
  validates_attachment :logo, content_type: {
    content_type: %w[image/png]
  }

  def self.find_by_name(name)
    Streamer.where('lower(site_name) = ?', name.downcase).first
  end
end
