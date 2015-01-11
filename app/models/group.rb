# == Schema Information
#
# Table name: groups
#
#  id                       :integer          not null, primary key
#  name                     :string(255)      not null
#  slug                     :string(255)      not null
#  bio                      :string(255)      default(""), not null
#  about                    :text             default(""), not null
#  avatar_file_name         :string(255)
#  avatar_content_type      :string(255)
#  avatar_file_size         :integer
#  avatar_updated_at        :datetime
#  cover_image_file_name    :string(255)
#  cover_image_content_type :string(255)
#  cover_image_file_size    :integer
#  cover_image_updated_at   :datetime
#  confirmed_members_count  :integer          default(0)
#  created_at               :datetime
#  updated_at               :datetime
#

class Group < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => [:slugged, :history]

  # We don't need to callback if we're killing the group off, just delete all
  # memberships.
  has_many :group_member_relations, dependent: :delete_all
  has_many :pending_members, -> { where(pending: true) },
    foreign_key: :group_id, class_name: 'GroupMember'
  has_many :members, -> { where(pending: false) },
    foreign_key: :group_id, class_name: 'GroupMember'

  has_attached_file :avatar,
    styles: {
      thumb: '190x190#',
      thumb_small: {geometry: '100x100#', animated: false, format: :jpg},
      small: {geometry: '50x50#', animated: false, format: :jpg}
    },
    convert_options: {
      thumb_small: '-quality 0',
      small: '-quality 0'
    },
    default_url: "https://hummingbird.me/default_avatar.jpg",
    processors: [:thumbnail, :paperclip_optimizer]

  validates_attachment :avatar, content_type: {
    content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  }

  process_in_background :avatar, processing_image_url: '/assets/processing-avatar.jpg'

  has_attached_file :cover_image,
    styles: {thumb: {geometry: "2880x800#", animated: false, format: :jpg}},
    convert_options: {thumb: '-interlace Plane -quality 0'},
    default_url: "https://hummingbird.me/default_cover.png"

  validates_attachment :cover_image, content_type: {
    content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  }

  validates :name,
    presence: true,
    uniqueness: {case_sensitive: false},
    length: {minimum: 3, maximum: 20}

  validate :at_least_one_admin
  def at_least_one_admin
    members.where(admin: true).count >= 1
  end

  def self.new_with_admin(params, admin)
    group = Group.new(params)
    group.members.build(
      user: admin,
      admin: true
    )
    group
  end

  def self.trending(count = 10)
    TrendingGroups.list(count)
  end
end
