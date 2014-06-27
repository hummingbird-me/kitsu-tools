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
#

class Manga < ActiveRecord::Base
  include PgSearch
  pg_search_scope :fuzzy_search_by_title, against: [:romaji_title, :english_title],
    using: {trigram: {threshold: 0.1}}, ranked_by: ":trigram"
  pg_search_scope :simple_search_by_title, against: [:romaji_title, :english_title],
    using: {tsearch: {normalization: 10, dictionary: "english"}}, ranked_by: ":tsearch"

  extend FriendlyId
  friendly_id :romaji_title, use: [:slugged, :history]

  attr_accessible :cover_image, :type, :cover_image_top_offset, :end_date, :english_title, :mal_id, :poster_image, :romaji_title, :serialization, :start_date, :status, :synopsis, :genres, :volume_count, :chapter_count

  # Internal Constants
  private
  
  VALID_TYPES =  ["Manga","Novel", "One Shot", "Doujin","Manwha", "Manhua", "OEL"]

  public

  validates :romaji_title, presence: true
  validates :type, inclusion: { in: VALID_TYPES }

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

  has_and_belongs_to_many :genres
  has_many :manga_library_entries, dependent: :destroy

  def poster_image_thumb
    if self.poster_image_file_name.nil?
      "http://hummingbird.me/assets/missing-anime-cover.jpg"
    else
      "http://static.hummingbird.me/manga/poster_images/#{"%03d" % (self.id/1000000 % 1000)}/#{"%03d" % (self.id/1000 % 1000)}/#{"%03d" % (self.id % 1000)}/large/#{self.poster_image_file_name}?#{self.poster_image_updated_at.to_i}"
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
      mal_id: (hash[:external_id] if manga.mal_id.nil?),
      english_title: (hash[:title][:en_us] if manga.english_title.nil?),
      romaji_title: (hash[:title][:en_jp] || hash[:title][:canonical] if manga.romaji_title.nil?),
      synopsis: (hash[:synopsis] if manga.synopsis.nil?),
      type: (hash[:type] if manga.type.nil?),
      poster_image: (hash[:poster_image] if manga.poster_image.nil?),
      genres: (begin hash[:genres].map { |g| Genre.find_by name: g }.compact rescue [] end if manga.genres.nil?),
      # TODO: replace this with a serialization table like producers?
      serialization: (hash[:serialization] if manga.serialization.nil?),
      volume_count: (hash[:volume_count] if manga.volume_count.nil?),
      chapter_count: (hash[:chapter_count] if manga.chapter_count.nil?),
      start_date: (begin hash[:dates][0] rescue nil end if manga.start_date.nil?),
      end_date: (begin hash[:dates][1] rescue nil end if manga.end_date.nil?),
      status: (hash[:status] if manga.status.nil?)
    }.compact)
    manga.save!
    manga
  end
end
