# == Schema Information
#
# Table name: characters
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  description        :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  mal_id             :integer
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  slug               :string(255)
#

class Character < ActiveRecord::Base
  include PgSearch
  pg_search_scope :instant_search,
    against: [ :name ],
    using: { tsearch: { normalization: 42, dictionary: 'english' } },
    ranked_by: ':tsearch'
  pg_search_scope :full_search,
    against: [ :name ],
    using: {
      tsearch: { normalization: 42, dictionary: 'english' },
      trigram: { threshold: 0.1 }
    },
    ranked_by: ':tsearch + :trigram'

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]
  def slug_candidates
    [
      :name,
      lambda { [:name, self.primary_media.canonical_title] }
    ]
  end

  validates :name, :presence => true
  has_many :castings, dependent: :destroy

  has_attached_file :image,
    styles: {thumb_small: "60x60#"},
    default_url: "/assets/default-avatar.jpg",
    convert_options: {all: "-unsharp 2x0.5+1+0"}

  validates_attachment :image, content_type: {
    content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  }

  def primary_media
    self.castings.first.media
  end

  def self.create_or_update_from_hash(hash)
    character = Character.find_by(mal_id: hash[:external_id])

    # NOTE: Ideally we'd find by name+series but that doesn't seem possible
    # Should we name+role?
    if character.nil? && Character.where(name: hash[:name]).count > 1
      logger.error "Count not find unique Character by name='#{hash[:name]}'."
      return
    end
    character ||= Character.find_by(name: hash[:name])
    character ||= Character.new({
      name: hash[:name],
      # Apparently we lack a corresponding field?
#     role: hash[:role]
    })
    character.image = hash[:image] if character.image.blank?
    character.mal_id = hash[:external_id] if character.mal_id.blank?
    character.save!
    character
  end
end
