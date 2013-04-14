class Anime < ActiveRecord::Base
  include PgSearch
  pg_search_scope :fuzzy_search_by_title, against: [:title, :alt_title], 
    using: [:trigram], ranked_by: ":trigram"
  pg_search_scope :simple_search_by_title, against: [:title, :alt_title], 
    using: {:tsearch => {:normalization => 10}}, ranked_by: ":tsearch"

  extend FriendlyId
  friendly_id :canonical_title, :use => [:slugged, :history]

  attr_accessible :title, :age_rating, :episode_count, :episode_length, :mal_id, 
    :status, :synopsis, :cover_image, :youtube_video_id, :alt_title,
    :thetvdb_series_id, :thetvdb_season_id

  has_attached_file :cover_image, 
    :styles => { :thumb => "225x335!", :"thumb@2x" => "450x670!" },
    :url => "/system/:hash_:style.:extension",
    :hash_secret => "Tsukiakari no Michishirube"

  has_many :quotes
  has_many :castings
  has_many :reviews
  has_many :episodes
  has_many :recommendations
  has_many :gallery_images
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :producers

  has_many :watchlists

  validates :title, :slug, :presence => true, :uniqueness => true

  # Filter out hentai if `filterp` is true or nil.
  def self.sfw_filter(current_user)
    if current_user && !current_user.sfw_filter
      self
    else
      where("age_rating <> 'Rx'")
    end
  end

  # Check whether the current anime is SFW.
  def sfw?
    age_rating != "Rx"
  end

  # Use this function to get the title instead of directly accessing the title.
  def canonical_title(current_user=nil)
    if alt_title and english_canonical
      return alt_title
    else
      return title
    end
  end
  # Use this function to get the alt title instead of directly accessing the 
  # alt_title.
  def alternate_title(current_user=nil)
    if english_canonical
      return title
    else
      return alt_title
    end
  end

  # Filter out all anime belonging to the genres passed in.
  def self.exclude_genres(genres)
    where('NOT EXISTS (SELECT 1 FROM anime_genres WHERE anime_genres.anime_id = anime.id AND anime_genres.genre_id IN (?))', genres.map(&:id))
  end

  # Find anime containing the genres passed in.
  # This complicated bit of SQL basically does relational division.
  def self.include_genres(genres)
    where('NOT EXISTS (
            SELECT * FROM genres AS g
            WHERE g.id IN (?)
            AND NOT EXISTS (
              SELECT *
              FROM anime_genres AS ag
              WHERE ag.anime_id = anime.id
              AND   ag.genre_id = g.id
            )
          )', genres.map(&:id))
  end

  # Return [age rating, guide]
  def self.convert_age_rating(rating)
    {
      nil                               => [nil,    nil],
      ""                                => [nil,    nil],
      "None"                            => [nil,    nil],
      "PG-13 - Teens 13 or older"       => ["PG13", "Teens 13 or older"],
      "R - 17+ (violence & profanity)"  => ["R17+", "Violence, Profanity"],
      "R+ - Mild Nudity"                => ["R17+", "Mild Nudity"],
      "PG - Children"                   => ["PG",   "Children"],
      "Rx - Hentai"                     => ["R18+", "Hentai"],
      "G - All Ages"                    => ["G",    "All Ages"],
      "PG-13"                           => ["PG13", "Teens 13 or older"],
      "R+"                              => ["R17+", "Mild Nudity"],
      "PG13"                            => ["PG13", "Teens 13 or older"],
      "G"                               => ["G",    "All Ages"],
      "PG"                              => ["PG",   "Children"]
    }[rating] || [rating, nil]
  end
  
  def get_metadata_from_mal
    meta = MalImport.series_metadata(self.mal_id)
    self.title = meta[:title]
    self.alt_title = meta[:english_title]
    self.synopsis = meta[:synopsis]
    self.cover_image = URI(meta[:cover_image_url]) if self.cover_image_file_name.nil?
    self.genres = (self.genres + meta[:genres]).uniq
    self.producers = (self.producers + meta[:producers]).uniq
    self.mal_age_rating = meta[:age_rating]
    self.age_rating, self.age_rating_guide = Anime.convert_age_rating(self.mal_age_rating)
    self.episode_count = meta[:episode_count]
    self.episode_length = meta[:episode_length]
    self.status = meta[:status]
    self.save
  end

  before_save do
    # If episode_count has increased, create new episodes.
    if self.episode_count and self.episodes.length < self.episode_count and (self.episodes.length == 0 or self.thetvdb_series_id.nil? or self.thetvdb_series_id.length == 0) 
      (self.episodes.length+1).upto(self.episode_count) do |n|
        Episode.create(anime_id: self.id, number: n)
      end
    end
  end
end
