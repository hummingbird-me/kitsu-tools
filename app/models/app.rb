# == Schema Information
#
# Table name: apps
#
#  id                :integer          not null, primary key
#  creator_id        :integer          not null
#  key               :string(255)      not null
#  secret            :string(255)      not null
#  name              :string(255)      not null
#  redirect_uri      :string(255)
#  homepage          :string(255)
#  description       :string(255)
#  privileged        :boolean          default(FALSE), not null
#  logo_file_name    :string(255)
#  logo_content_type :string(255)
#  logo_file_size    :integer
#  logo_updated_at   :datetime
#  write_access      :boolean          default(FALSE), not null
#  public            :boolean          default(FALSE), not null
#

class App < ActiveRecord::Base
  belongs_to :creator, class_name: 'User'
  has_attached_file :logo,
    styles: { thumb: '200x200#' },
    path: "/:class/:attachment/:id/:style.:content_type_extension",
    default_url: "https://hummingbird.me/default_avatar.jpg",
    processors: [:thumbnail, :paperclip_optimizer]

  validates :creator, presence: true
  validates :name, presence: true, uniqueness: true, length: { maximum: 32 }
  validates :key, uniqueness: true
  validates :redirect_uri, format: { without: %r[\Ahttp://] }
  validates :redirect_uri, presence: true, if: :write_access?
  validates :description, length: { maximum: 140 }
  validates_attachment :logo, content_type: {
    content_type: ["image/jpg", "image/jpeg", "image/png"]
  }

  process_in_background :logo, processing_image_url: '/assets/processing-avatar.jpg'

  before_create do
    self.key = SecureRandom.hex(10) unless self.key
    self.secret = SecureRandom.base64(30) unless self.secret
  end
end
