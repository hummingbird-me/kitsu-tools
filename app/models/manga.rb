# == Schema Information
#
# Table name: manga
#
#  id                        :integer          not null, primary key
#  romaji_title              :string(255)
#  slug                      :string(255)
#  english_title             :string(255)
#  synopsis                  :text             default(""), not null
#  poster_image_file_name    :string(255)
#  poster_image_content_type :string(255)
#  poster_image_file_size    :integer
#  poster_image_updated_at   :datetime
#  cover_image_file_name     :string(255)
#  cover_image_content_type  :string(255)
#  cover_image_file_size     :integer
#  cover_image_updated_at    :datetime
#  start_date                :date
#  end_date                  :date
#  serialization             :string(255)
#  mal_id                    :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  status                    :string(255)
#  cover_image_top_offset    :integer          default(0)
#  volume_count              :integer
#  chapter_count             :integer
#  manga_type                :string(255)      default("Manga")
#

class Manga < ActiveRecord::Base
  include PgSearch
  pg_search_scope :fuzzy_search_by_title, against: [:romaji_title, :english_title],
    using: {trigram: {threshold: 0.1}}, ranked_by: ":trigram"
  pg_search_scope :simple_search_by_title, against: [:romaji_title, :english_title],
    using: {tsearch: {normalization: 10, dictionary: "english"}}, ranked_by: ":tsearch"

  extend FriendlyId
  friendly_id :romaji_title, use: [:slugged, :history]

  # Internal Constants
  private

  VALID_TYPES =  ["Manga", "Novel", "One Shot", "Doujin", "Manwha", "Manhua", "OEL"]

  public

  validates :romaji_title, presence: true
  validates :manga_type, inclusion: { in: VALID_TYPES }

  has_attached_file :cover_image,
    styles: {thumb: ["1400x900>", :jpg]},
    convert_options: {thumb: "-quality 70 -colorspace Gray"}

  validates_attachment :cover_image, content_type: {
    content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  }

  has_attached_file :poster_image, default_url: "/assets/missing-anime-cover.jpg",
    styles: {large: "200x290!", medium: "100x150!"}

  validates_attachment :poster_image, content_type: {
    content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  }

  has_many :castings, dependent: :destroy, as: :castable
  has_and_belongs_to_many :genres
  has_many :manga_library_entries, dependent: :destroy

  def poster_image_thumb
    if self.poster_image_file_name.nil?
      "http://hummingbird.me/assets/missing-anime-cover.jpg"
    else
      # This disgusting fastpath brought to you by the following issue:
      # https://github.com/thoughtbot/paperclip/issues/909
      if Rails.env.production?
        "http://static.hummingbird.me/manga/poster_images/#{"%03d" % (self.id/1000000 % 1000)}/#{"%03d" % (self.id/1000 % 1000)}/#{"%03d" % (self.id % 1000)}/large/#{self.poster_image_file_name}?#{self.poster_image_updated_at.to_i}"
      else
        self.poster_image.url(:large)
      end
    end
  end

  def self.create_or_update_from_hash hash
    # First the creation logic
    # TODO: stop hard-coding the ID column
    manga = Manga.find_by(mal_id: hash[:external_id])
    if manga.nil? && Manga.where(romaji_title: hash[:romaji_title]).count > 1
      log "Could not find unique Manga by romaji_title=#{hash[:romaji_title]}.  Ignoring."
      return
    end
    manga ||= Manga.find_by(romaji_title: hash[:romaji_title])
    manga ||= Manga.new

    # Metadata
    manga.assign_attributes({
      mal_id: (hash[:external_id] if manga.mal_id.blank?),
      english_title: (hash[:title][:en_us] if manga.english_title.blank?),
      romaji_title: (hash[:title][:en_jp] || hash[:title][:canonical] if manga.romaji_title.blank?),
      synopsis: (hash[:synopsis] if manga.synopsis.blank?),
      # Wondering why this doesn't have an if blank?
      # Well, some jerk put a DEFAULT on the column, so it's never blank.
      manga_type: hash[:type],
      poster_image: (hash[:poster_image] if manga.poster_image.blank?),
      genres: (begin hash[:genres].map { |g| Genre.find_by name: g }.compact rescue [] end if manga.genres.blank?),
      # TODO: replace this with a serialization table like producers?
      serialization: (hash[:serialization] if manga.serialization.blank?),
      volume_count: (hash[:volume_count] if manga.volume_count.blank?),
      chapter_count: (hash[:chapter_count] if manga.chapter_count.blank?),
      start_date: (begin hash[:dates][0] rescue nil end if manga.start_date.blank?),
      end_date: (begin hash[:dates][1] rescue nil end if manga.end_date.blank?),
      status: (hash[:status] if manga.status.blank?)
    }.compact)
    # Staff castings
    hash[:staff].each do |staff|
      Casting.create_or_update_from_hash staff.merge({
        castable: manga
      })
    end
    # Character castings
    hash[:characters].each do |ch|
      character = Character.create_or_update_from_hash ch
      Casting.create_or_update_from_hash({
        featured: ch[:featured],
        character: character,
        castable: manga
      })
    end
    manga.save!
    manga
  end
end
