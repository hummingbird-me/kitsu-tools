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
  VALID_SCOPES = %i[all public_profile]

  belongs_to :creator, class_name: 'User'
  has_attached_file :logo,
    styles: { thumb: '200x200#' },
    path: "/:class/:attachment/:id/:style.:content_type_extension",
    default_url: "https://hummingbird.me/default_avatar.jpg",
    processors: [:thumbnail, :paperclip_optimizer]

  validates :creator, presence: true
  validates :name, presence: true, uniqueness: true, length: { maximum: 32 }
  validates :key, uniqueness: true
  with_options if: :write_access? do |app|
    app.validates :redirect_uri, format: { without: %r[\Ahttp://] }
    app.validate :validate_redirect_has_fragment
    app.validates :redirect_uri, presence: true
  end
  validates :description, length: { maximum: 140 }
  validates_attachment :logo, content_type: {
    content_type: ["image/jpg", "image/jpeg", "image/png"]
  }

  process_in_background :logo, processing_image_url: '/assets/processing-avatar.jpg'

  def validate_redirect_has_fragment
    fragment = URI(redirect_uri.to_s).fragment
    errors.add(:redirect_uri, 'must not have fragment') unless fragment.blank?
  end

  def redirect_allowed?(uri)
    redirect_uri == uri.to_s
  end

  def scope_allowed?(scope)
    return false unless VALID_SCOPES.include?(scope)
    privileged? || scope.to_s != 'all'
  end

  def scopes_allowed?(scopes)
    scopes.all? { |x| scope_allowed?(x) }
  end

  def build_redirect_uri(type, params)
    qs = Rack::Utils.build_query(params)

    if type == :query_string
      # "Authorization Code Grant", "Three-legged", or "Server-side" flow (4.1)
      # TODO: prevent this from mangling the slashes of protocols
      uri = URI(redirect_uri)
      uri.query = uri.query ? "#{uri.query}&#{qs}" : qs
      uri.to_s
    elsif type == :fragment
      # "Implicit Grant" or "Browser-based" flow (4.2)
      "#{redirect_uri}##{qs}"
    end
  end

  before_create do
    self.key = SecureRandom.hex(10) unless self.key
    self.secret = SecureRandom.base64(30) unless self.secret
  end
end
