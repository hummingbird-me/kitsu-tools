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
#  bayesian_rating           :float
#  rating_frequencies        :hstore           default({}), not null
#

class Manga < ActiveRecord::Base
  PG_TITLE_SCOPE = %i(romaji_title english_title)

  VALID_TYPES =  ['Manga', 'Novel', 'One Shot', 'Doujin', 'Manhwa', 'Manhua', 'OEL']

  include Media

  friendly_id :romaji_title, use: %i(slugged history)

  has_many :manga_library_entries, dependent: :destroy

  validates :romaji_title, presence: true
  validates :manga_type, inclusion: { in: VALID_TYPES }

  def canonical_title
    romaji_title
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
      # These fields are always more accurate elsewhere
      volume_count: hash[:volume_count],
      chapter_count: hash[:chapter_count],
      start_date: begin hash[:dates][0] rescue nil end,
      end_date: begin hash[:dates][1] rescue nil end,
      status: hash[:status]
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

  # Versionable overrides
  def create_pending(author, object = {})
    # check if URL is the same, otherwise paperclip will determine
    # that it is a new image based on `original` filesize compared to
    # the linked thumbnail filesize.
    if object[:poster_image] == self.poster_image.url(:large)
      object.delete(:poster_image)
    end
    if object[:cover_image] == self.cover_image.url(:thumb)
      object.delete(:cover_image)
    end
    super
  end
end
